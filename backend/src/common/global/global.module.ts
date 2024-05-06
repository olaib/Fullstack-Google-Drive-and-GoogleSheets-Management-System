import { Module } from '@nestjs/common';
import { HelpersService } from '../helpers/helpers.service';

@Module({
    imports: [HelpersService],
    exports: [HelpersService],
})
export class GlobalModule {}
