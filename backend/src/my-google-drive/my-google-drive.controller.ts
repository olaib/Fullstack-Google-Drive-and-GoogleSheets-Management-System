import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Post,
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
  async getFilesUrls(@Body() filesIds: Array<string>): Promise<any> {
    return this.myGoogleDriveService.getPreviewUrls(filesIds);
  }

  @Get('get/view')
  async getViewUrl(@Param('fileId') fileId: string): Promise<any> {
    return this.myGoogleDriveService.getPreviewUrl(fileId);
  }

  @Get('get/view/urls')
  async getViewUrls(@Body() filesIds: Array<string>): Promise<any> {
    return this.myGoogleDriveService.getPreviewUrls(filesIds);
  }
}
