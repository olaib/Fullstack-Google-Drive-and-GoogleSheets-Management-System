import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { GoogleDriveService } from 'nestjs-google-drive';
import * as fs from 'fs';
import {
  FILE_ID,
  GOOGLE_DRIVE_PREVIEW_URL,
  GOOGLE_DRIVE_VIEW_URL,
  GDRIVE_AUTH_URL,
  GOOGLE_DRIVE_REDIRECT_URL,
  GSHEETS_AUTH_URL,
} from '../constants';
import { unlinkSync } from 'fs';
import { GoogleAuthService } from 'src/google-auth/google-auth.service';
const { google } = require('googleapis');

//todo: manage all drive files by getting all the files inside the root folder

@Injectable()
export class MyGoogleDriveService {

  private gDrive: any;
  constructor(private readonly googleAuth: GoogleAuthService) {
    const googleClientId = googleAuth.getOAuth2Client();
    this.gDrive = google.drive({
      version: 'v3',
      auth: googleClientId,
    });
  }

  /**
   * get all files in the drive
   * @param folderId - id of the folder to get the files of
   * @returns - files in the drive
   * */
  async getFiles(folderId: string): Promise<any> {
    // files that are not deleted
    const res = await this.gDrive.files.list({
      //q: mimeType = 'application/vnd.google-apps.folder' and trashed = false
      q: `'${folderId}' in parents and trashed = false`,
      pageSize: 10, // set the number of files to get
      fields: 'nextPageToken, files(id, name, mimeType, size, modifiedTime)',
    });
    return res.data.files;
  }

  /**
   * get all folders in specific folder
   * @param folderId - id of the folder to get the folders of
   * @returns - folders in the folder
   * */
  async getFolders(folderId: string): Promise<any> {
    // folders that are not deleted
    const res = await this.gDrive.files.list({
      q: `'${folderId}' in parents and mimeType = 'application/vnd.google-apps.folder' and trashed = false`,
      pageSize: 20, // desired number of folders to get
      fields: 'nextPageToken, files(id, name)',
    });
    return res.data.files;
  }

  /**
   * upload file to google drive
   * @param folderId - folder id to upload the file to
   * @param file - file to upload as a buffer
   * @returns - file id of the uploaded file
   */
  async uploadFile(
    folderId: string,
    file: Express.Multer.File,
  ): Promise<{ fileId: string; name: string }> {
    try {
      const resources = {
        name: file.originalname,
        parents: [folderId],
      };
      const media = {
        mimeType: file.mimetype,
        body: fs.createReadStream(file.path),
      };
      const res = await this.gDrive.files.create({
        resource: resources,
        media: media,
        fields: 'id',
      });
      const fileId = res.data.id;
      // delete temporary file from the server after uploading them to the drive
      unlinkSync(file.path);

      return { fileId, name: file.originalname };
    } catch (error) {
      throw new HttpException(
        'Failed to upload file',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  /**
   * upload many files to google drive
   * @see uploadFile
   * @param folderId - folder id to upload the files to
   * @param files- files to upload
   * @returns - file ids of the uploaded files
   */
  async uploadMany(
    folderId: string,
    files: Array<Express.Multer.File>,
  ): Promise<{ fileId: string; name: string }[]> {
    const foldersIds = Promise.all(
      files.map(async (file) => await this.uploadFile(folderId, file)),
    );

    return foldersIds;
  }

  /**
   * delete file from google drive
   * @param fileId - file id to delete
   * @returns - status of the deletion
   */
  async deleteFile(fileId: string): Promise<void> {
    try {
      await this.gDrive.files.delete({
        fileId: fileId,
      });
    } catch (error) {
      throw new HttpException(
        'Failed to delete file',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  /**
   * delete many files from google drive
   * @param filesIds - files ids to delete
   */
  async deleteMany(filesIds: Array<string>): Promise<void> {
    filesIds.forEach(async (fileId) => await this.deleteFile(fileId));
  }

  /**
   * get url of the file(download url)
   * @param fileId - file id to get the url of
   * @returns - url of the file
   */
  async getFileUrl(fileId: string) {
    const res = await this.gDrive.files.get({
      fileId: fileId,
      fields: 'webContentLink',
    });
    return res.data.webContentLink;
  }

  /**
   * get urls of many files(download urls)
   * @param filesIds - files ids to get the urls of
   * @returns - urls of the files
   * @see getFileUrl
   */
  async getFilesUrls(
    filesIds: Array<string>,
  ): Promise<{ url: string; fileId: string }[]> {
    const filesUrls = Promise.all(
      filesIds.map(async (fileId) => {
        const url = await this.getFileUrl(fileId);
        return {
          url,
          fileId,
        };
      }),
    );
    return filesUrls;
  }

  /**
   * get preview url of the file(url to view the file in the browser with the preview option)
   * @param fileId - file id to get the preview url of
   * @returns - preview url of the file
   */
  getPreviewUrl(fileId: string): string {
    return GOOGLE_DRIVE_PREVIEW_URL.replace(FILE_ID, fileId);
  }

  /**
   * get preview urls of many files(url to view the files in the browser with the preview option)
   * @param filesIds - files ids to get the preview urls of
   * @returns - preview urls of the files
   * @see getPreviewUrl
   */
  getPreviewUrls(
    filesIds: Array<string>,
  ): Promise<{ url: string; fileId: string }[]> {
    const filesUrls = Promise.all(
      filesIds.map(async (fileId) => {
        const url = await this.getPreviewUrl(fileId);
        return {
          url,
          fileId,
        };
      }),
    );
    return filesUrls;
  }

  /**
   * get view url of the file(url to view the file in the browser)
   * @param fileId - file id to get the view url of
   * @returns - view url of the file
   */
  getViewUrl(fileId: string): string {
    return GOOGLE_DRIVE_VIEW_URL.replace(FILE_ID, fileId);
  }

  /**
   * get view urls of many files(url to view the files in the browser)
   * @param filesIds - files ids to get the view urls of
   * @returns - view urls of the files
   * @see getViewUrl
   */
  getViewUrls(
    filesIds: Array<string>,
  ): Promise<{ url: string; fileId: string }[]> {
    const filesUrls = Promise.all(
      filesIds.map(async (fileId) => {
        const url = await this.getViewUrl(fileId);
        return {
          url,
          fileId,
        };
      }),
    );
    return filesUrls;
  }

  /**
   * get file's info
   * @param folderId - id of the folder to get info of
   * @returns - root folder of the drive
   * */
  async getFileInfo(folderId: string): Promise<any> {
    const res = await this.gDrive.files.get({
      fileId: folderId,
      fields: '*',
    });
    return res.data;
  }

  /**
   * create a folder in the drive
   * @param folderName - name of the folder to create
   * @param parentFolderId - id of the parent folder to create the folder in
   * @returns - id of the created folder
   */
  async createFolder(
    folderName: string,
    parentFolderId: string,
  ): Promise<string> {
    const resource = {
      name: folderName,
      mimeType: 'application/vnd.google-apps.folder',
      parents: [parentFolderId],
    };
    const res = await this.gDrive.files.create({
      resource: resource,
      fields: 'id',
    });
    return res.data.id;
  }

  /**
   * get the folder by name
   * @param folderName - name of the folder to get
   * @returns - folder with the folder name
   */
  async getFolderByName(folderName: string): Promise<any> {
    const res = await this.gDrive.files.list({
      q: `name='${folderName}'`,
      fields: 'files(id, name)',
    });
    return res.data.files;
  }

  /**
   * get the folder by id
   * @param folderId - id of the folder to get
   * @returns - folder with the folder id
   */
  async getFolderById(folderId: string): Promise<any> {
    const res = await this.gDrive.files.get({
      fileId: folderId,
      fields: 'id, name',
    });
    return res.data;
  }

  /**
   * get the files in a folder
   * @param folderId - id of the folder to get the files of
   * @returns - files in the folder
   */
  async getFilesInFolder(folderId: string): Promise<any> {
    const res = await this.gDrive.files.list({
      q: `'${folderId}' in parents`,
      fields: 'files(id, name)',
    });
    return res.data.files;
  }

  /**
   * get the folders in a folder
   * @param folderId - id of the folder to get the folders of
   * @returns - folders in the folder
   */
  async getFoldersInFolder(folderId: string): Promise<any> {
    const res = await this.gDrive.files.list({
      q: `'${folderId}' in parents`,
      fields: 'files(id, name)',
    });
    return res.data.files;
  }

  /**
   * get the parent folder of a file
   * @param fileId - id of the file to get the parent folder of
   * @returns - parent folder of the file
   */
  async getParentFolder(fileId: string): Promise<any> {
    const res = await this.gDrive.files.get({
      fileId: fileId,
      fields: 'parents',
    });
    return res.data.parents;
  }

  //   return await this.googleDriveService.deleteFile(fileId);
  // }

  // /**
  //  * delete many files from google drive
  //  * @param filesIds - files ids to delete
  //  */
  // async deleteMany(filesIds: Array<string>): Promise<void> {
  //   filesIds.forEach(
  //     async (fileId) => await this.googleDriveService.deleteFile(fileId),
  //   );
  // }

  // /**
  //  * get url of the file(download url)
  //  * @param fileId - file id to get the url of
  //  * @returns - url of the file
  //  */
  // async getFileUrl(fileId: string): Promise<string> {
  //   return await this.googleDriveService.getFileURL(fileId);
  // }

  // /**
  //  * get urls of many files(download urls)
  //  * @param filesIds - files ids to get the urls of
  //  * @returns - urls of the files
  //  * @see getFileUrl
  //  */
  // async getFilesUrls(
  //   filesIds: Array<string>,
  // ): Promise<{ [key: string]: string }[]> {
  //   const filesUrls: Promise<{ [key: string]: string }[]> = Promise.all(
  //     filesIds.map(async (fileId) => {
  //       const url: string = await this.getFileUrl(fileId);
  //       return {
  //         url,
  //         fileId,
  //       };
  //     }),
  //   );
  //   return filesUrls;
  // }

  // /**
  //  * get preview url of the file(url to view the file in the browser with the preview option)
  //  * @param fileId - file id to get the preview url of
  //  * @returns - preview url of the file
  //  */
  // getPreviewUrl(fileId: string): string {
  //   return GOOGLE_DRIVE_PREVIEW_URL.replace(FILE_ID, fileId);
  // }

  // /**
  //  * get preview urls of many files(url to view the files in the browser with the preview option)
  //  * @param filesIds - files ids to get the preview urls of
  //  * @returns - preview urls of the files
  //  * @see getPreviewUrl
  //  */
  // getPreviewUrls(
  //   filesIds: Array<string>,
  // ): Promise<{ url: string; fileId: string }[]> {
  //   const filesUrls = Promise.all(
  //     filesIds.map(async (fileId) => {
  //       const url: string = await this.getPreviewUrl(fileId);
  //       return {
  //         url,
  //         fileId,
  //       };
  //     }),
  //   );
  //   return filesUrls;
  // }

  // /**
  //  * get view url of the file(url to view the file in the browser)
  //  * @param fileId - file id to get the view url of
  //  * @returns - view url of the file
  //  */
  // getViewUrl(fileId: string) {
  //   return GOOGLE_DRIVE_VIEW_URL.replace(FILE_ID, fileId);
  // }

  // /**
  //  * get view urls of many files(url to view the files in the browser)
  //  * @param filesIds - files ids to get the view urls of
  //  * @returns - view urls of the files
  //  * @see getViewUrl
  //  */
  // getViewUrls(
  //   filesIds: Array<string>,
  // ): Promise<{ url: string; fileId: string }[]> {
  //   const filesUrls = Promise.all(
  //     filesIds.map(async (fileId) => {
  //       const url: string = await this.getViewUrl(fileId);
  //       return {
  //         url,
  //         fileId,
  //       };
  //     }),
  //   );
  //   return filesUrls;
  // }
}
