import { Test, TestingModule } from '@nestjs/testing';
import { MyGoogleDriveController } from './my-google-drive.controller';

describe('MyGoogleDriveController', () => {
  let controller: MyGoogleDriveController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [MyGoogleDriveController],
    }).compile();

    controller = module.get<MyGoogleDriveController>(MyGoogleDriveController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
