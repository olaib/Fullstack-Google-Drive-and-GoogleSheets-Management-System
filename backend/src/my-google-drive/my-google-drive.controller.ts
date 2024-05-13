import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Post,
  Query,
  UploadedFile,
  UploadedFiles,
  UseInterceptors,
} from '@nestjs/common';
import { MyGoogleDriveService } from './my-google-drive.service';
import { FileInterceptor } from '@nestjs/platform-express';

@Controller('google-drive')
export class MyGoogleDriveController {
  constructor(private readonly myGoogleDriveService: MyGoogleDriveService) {}

  @Post('upload/file/:folderId')
  @UseInterceptors(FileInterceptor('file', { dest: './uploads' }))
  async uploadFile(
    @Param('folderId') folderId: string,
    @UploadedFile() file: Express.Multer.File,
  ): Promise<any> {
    return this.myGoogleDriveService.uploadFile(folderId, file);
  }

  @Post('upload/:folderId')
  @UseInterceptors(FileInterceptor('files', { dest: './uploads' }))
  uploadFiles(
    @UploadedFiles() files: Array<Express.Multer.File>,
    @Param('folderId') folderId: string,
  ): Promise<any> {
    return this.myGoogleDriveService.uploadMany(folderId, files);
  }

  @Delete('delete/:fileId')
  async deleteFile(@Param('fileId') fileId: string): Promise<any> {
    return this.myGoogleDriveService.deleteFile(fileId);
  }

  @Delete('delete')
  async deleteFiles(@Body() filesIds: Array<string>): Promise<any> {
    return this.myGoogleDriveService.deleteMany(filesIds);
  }

  @Get('get/file/url')
  async getFileUrl(@Param('fileId') fileId: string): Promise<any> {
    return this.myGoogleDriveService.getFileUrl(fileId);
  }

  @Get('get/previews/:fileId')
  async getPreviewUrl(@Param('fileId') fileId: string): Promise<any> {
    return this.myGoogleDriveService.getPreviewUrl(fileId);
  }

  @Get('get/previews')
  getFilesUrls(@Body() filesIds: Array<string>): any {
    return this.myGoogleDriveService.getPreviewUrls(filesIds);
  }

  @Get('get/view')
  getViewUrl(@Param('fileId') fileId: string): any {
    return this.myGoogleDriveService.getPreviewUrl(fileId);
  }

  @Get('get/view/urls')
  getViewUrls(@Body() filesIds: Array<string>): Promise<any> {
    return this.myGoogleDriveService.getPreviewUrls(filesIds);
  }

  @Get('list/:folderId')
  async getFiles(@Param('folderId') folderId: string): Promise<any> {
    return await this.myGoogleDriveService.getFiles(folderId);
  }

  @Get('file/details/:fileId')
  async getFile(@Param('fileId') fileId: string): Promise<any> {
    return await this.myGoogleDriveService.getFileInfo(fileId);
  }

  //createFolder params query
  @Post('create/folder/:folderId')
  async createFolder(
    @Query('folderName') folderName: string,
    @Param('folderId') folderId: string,
  ): Promise<any> {
    return await this.myGoogleDriveService.createFolder(folderName, folderId);
  }

  // get folders in specific folder
  @Get('folders/:folderId')
  async getFolders(@Param('folderId') folderId: string): Promise<any> {
    return await this.myGoogleDriveService.getFolders(folderId);
  }
}
