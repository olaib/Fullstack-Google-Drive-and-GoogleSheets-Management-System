import { Injectable, OnModuleInit } from '@nestjs/common';
import {
  SWAGGER_API_ENDPOINT,
  TEST_ENDPOINTS_MESSAGE,
  WELCOME_MESSAGE,
} from './constants';
import { RolesService } from './roles/roles.service';
import { StatusService } from './statuses/status.service';

@Injectable()
export class AppService implements OnModuleInit {
  constructor(
    private readonly rolesService: RolesService,
    private readonly statusesService: StatusService,
  ) {}

  async onModuleInit() {
    const roles = await this.rolesService.findAll();
    const statuses = await this.statusesService.findAll();

    [
      {
        name: 'admin',
        exists: roles.some((role) => role.name === 'admin'),
      },
      {
        name: 'user',
        exists: roles.some((role) => role.name === 'user'),
      },
    ].forEach(async (role) => {
      if (!role.exists) {
        await this.rolesService.create({ name: role.name });
      }
    });

    [
      {
        name: 'בלוח משימות',
        priority: 0,
        exists: statuses.some((status) => status.name === 'בלוח משימות' || status.priority === 0),
      },
      { 
        name: 'בחוץ',
        priority: 1,
        exists: statuses.some((status) => status.name === 'בחוץ' || status.priority === 1),
      },
    ].forEach(async (status) => {
      if (!status.exists) {
        await this.statusesService.create({
          name: status.name,
          priority: status.priority,
        });
      }
    });
  }
  getHello(): string {
    return `
      <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
      <div class="d-flex flex-column justify-content-center align-items-center vh-100 text-center bg-light">
        <h1 class="text-dark">${WELCOME_MESSAGE}</h1>
        <h2 class="text-secondary">Hello World! 👋</h2>
        <p>${TEST_ENDPOINTS_MESSAGE}</p>
        <p class="text-secondary">Created by Ola Ibrahim</p>
        <div class="d-flex justify-content-center align-items-center mt-3">
          <a href="" class="text-dark mx-2"><i class="fab fa-github"></i> GitHub</a>
          <a href="" class="text-dark mx-2"><i class="fab fa-linkedin"></i> LinkedIn</a>
        </div>
      </div>
    `;
  }
}
