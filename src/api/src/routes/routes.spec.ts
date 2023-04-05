import request from "supertest";
import { Server } from "http";
import { Express } from "express";
import { createApp } from "../app";

describe("SimpleAPI", () => {
    let app: Express;
    let server: Server;

    beforeAll(async () => {
        app = await createApp();
        const port = process.env.PORT || 3100;

        server = app.listen(port, () => {
            console.log(`Started listening on port ${port}`);
        });
    });

    afterAll((done) => {
        server.close(done);
        console.log("Stopped server");
    });

    describe("Health Check Routes", () => {
        it("can health status", async () => {

            const res = await getHealth();

            expect(res.statusCode).toEqual(200);
            expect(res.body.length).toBeGreaterThan(0);
        });
    });

    const getHealth = (query = "") => {
        return request(app)
            .get("/live")
            .query(query)
            .send();
    };
});
