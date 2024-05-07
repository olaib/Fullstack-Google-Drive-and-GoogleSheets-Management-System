import { Injectable } from '@nestjs/common';
import { GoogleDriveService } from 'nestjs-google-drive';
import {
  FILE_ID,
  GOOGLE_DRIVE_PREVIEW_URL,
  GOOGLE_DRIVE_VIEW_URL,
} from '../constants';
import { unlinkSync } from 'fs';

//todo: manage all drive files by getting all the files inside the root folder

@Injectable()
export class MyGoogleDriveService {
  constructor(private readonly googleDriveService: GoogleDriveService) {}

  /**
   * upload file to google drive
   * @param folderId - folder id to upload the file to
   * @param file - file to upload
   * @returns - file id of the uploaded file
   */
  async uploadFile(
    folderId: string,
    file: Express.Multer.File,
  ): Promise<String> {
    const fileId = await this.googleDriveService.uploadFile(file, folderId);
    // delete temporary file from the server after uploading them to the drive
    unlinkSync(file.path);

    return fileId;
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
  ): Promise<String[]> {
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
  async deleteFile(fileId: string) {
    return await this.googleDriveService.deleteFile(fileId);
  }

  /**
   * delete many files from google drive
   * @param filesIds - files ids to delete
   */
  async deleteMany(filesIds: Array<string>): Promise<void> {
    filesIds.forEach(
      async (fileId) => await this.googleDriveService.deleteFile(fileId),
    );
  }

  /**
   * get url of the file(download url)
   * @param fileId - file id to get the url of
   * @returns - url of the file
   */
  async getFileUrl(fileId: string): Promise<string> {
    return await this.googleDriveService.getFileURL(fileId);
  }

  /**
   * get urls of many files(download urls)
   * @param filesIds - files ids to get the urls of
   * @returns - urls of the files
   * @see getFileUrl
   */
  async getFilesUrls(
    filesIds: Array<string>,
  ): Promise<{ [key: string]: string }[]> {
    const filesUrls: Promise<{ [key: string]: string }[]> = Promise.all(
      filesIds.map(async (fileId) => {
        const url: string = await this.getFileUrl(fileId);
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
        const url: string = await this.getPreviewUrl(fileId);
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
  getViewUrl(fileId: string) {
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
        const url: string = await this.getViewUrl(fileId);
        return {
          url,
          fileId,
        };
      }),
    );
    return filesUrls;
  }
}
