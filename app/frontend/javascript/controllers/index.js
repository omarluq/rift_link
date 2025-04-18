// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application";
import { registerControllers } from "stimulus-vite-helpers";

const controllers = import.meta.glob("./**/*_controller.js", { eager: true });
registerControllers(application, controllers);
