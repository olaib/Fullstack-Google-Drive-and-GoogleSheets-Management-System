import { Injectable } from '@nestjs/common';
import { GoogleDriveService } from 'nestjs-google-drive';
import { GOOGLE_DRIVE_PREVIEW_URL, GOOGLE_DRIVE_VIEW_URL } from '../constants';
//todo: manage all drive files by getting all the files inside the root folder
@Injectable()
export class MyGoogleDriveService {
  constructor(private readonly googleDriveService: GoogleDriveService) {}

  async uploadMany(folderId: string, files: Array<Express.Multer.File>) {
    files.forEach(async (file) => {
      await this.googleDriveService.uploadFile(file, folderId);
    });
  }

  async uploadFile(folderId: string, file: Express.Multer.File) {
    return await this.googleDriveService.uploadFile(file, folderId);
  }

  async deleteFile(fileId: string) {
    return await this.googleDriveService.deleteFile(fileId);
  }

  async deleteMany(filesIds: Array<string>) {
    filesIds.forEach(
      async (fileId) => await this.googleDriveService.deleteFile(fileId),
    );
  }
  // download url
  async getFileUrl(fileId: string) {
    return await this.googleDriveService.getFileURL(fileId);
  }
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
  // view vs preview: view is the file in the browser, preview is the file in the browser with the preview option like sharing and downloading

  getPreviewUrl(fileId: string): string {
    return GOOGLE_DRIVE_PREVIEW_URL.replace('fileId', fileId);
  }
  getPreviewUrls(
    filesIds: Array<string>,
  ): Promise<{ [key: string]: string }[]> {
    const filesUrls: Promise<{ [key: string]: string }[]> = Promise.all(
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

  getViewUrl(fileId: string) {
    return GOOGLE_DRIVE_VIEW_URL.replace('fileId', fileId);
  }

  getViewUrls(filesIds: Array<string>): Promise<{ [key: string]: string }[]> {
    const filesUrls: Promise<{ [key: string]: string }[]> = Promise.all(
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
