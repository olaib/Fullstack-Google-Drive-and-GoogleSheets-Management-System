import { Test, TestingModule } from '@nestjs/testing';
import { MyGoogleDriveService } from './my-google-drive.service';

describe('MyGoogleDriveService', () => {
  let service: MyGoogleDriveService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [MyGoogleDriveService],
    }).compile();

    service = module.get<MyGoogleDriveService>(MyGoogleDriveService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
