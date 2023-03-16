import express, { Express } from "express";
import swaggerUI from "swagger-ui-express";
import cors from "cors";
import yaml from "yamljs";
import { getConfig } from "./config";
import { configureMongoose } from "./models/mongoose";
import { observability } from "./config/observability";

export const createApp = async (): Promise<Express> => {
    const config = await getConfig();
    const app = express();

    // Configuration
    observability(config.observability);
    const dbStatus = await configureMongoose(config.database);

    // Middleware
    app.use(express.json());
    app.use(cors());

    // API Health Check
    app.use("/live", function (req, res) {

        if(dbStatus){
            res.send("Well Done");
        } else{
            res.status(500).send("Maintenance");
        }

    });

    // Swagger UI
    const swaggerDocument = yaml.load("./openapi.yaml");
    app.use("/", swaggerUI.serve, swaggerUI.setup(swaggerDocument));

    return app;
};
