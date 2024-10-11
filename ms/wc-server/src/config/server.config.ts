import { json, urlencoded } from 'body-parser';
import { Application, NextFunction, Request, Response } from 'express';
import { BaseException, InternalServerException } from './exception.config';
import morgan from 'morgan';

export async function serverConfig(app: Application) {
  app.use(
    urlencoded({
      extended: true,
    })
  );
  app.use(json());
  morgan.token('date', function(){
    return new Date().toISOString()
  })
  app.use(morgan('combined'));

}

export function serverErrorConfig(app: Application) {
  app.use((err: Error, _req: Request, res: Response, next: NextFunction) => {
    if (err && err instanceof BaseException) {
      return res.status(err.statusCode).json(err);
    }

    if (err) {
      return res.status(500).json(new InternalServerException(err.message));
    }
    next();
  });
}
