import { injectable } from 'inversify';
import { format, createLogger, transports } from 'winston';

const { colorize, combine, label, printf, timestamp } = format;

@injectable()
export class Logger {
  private logger = createLogger({
    level: 'debug',
    format: combine(
      label({ label: '[LOGGER]' }),
      timestamp({
        format: 'MMM-DD-YYYY HH:mm:ss',
      }),
      colorize({
        all: true,
        colors: {
          info: 'bold blue', // fontStyle color
          warn: 'italic yellow',
          error: 'bold red',
          debug: 'green',
        },
      }),
      printf(function (info) {
        return `\x1B[33m\x1B[3[${info.label}\x1B[23m\x1B[39m \x1B[32m${info.timestamp}\x1B[39m ${info.level} : ${info.message}`;
      })
    ),
    transports: [new transports.Console()],
  });

  public info(message: any) { // Removed callback parameter
    this.logger.info(message);
  }

  public warn(message: any) { // Removed callback parameter
    this.logger.warn(message);
  }

  public error(message: any) { // Removed callback parameter
    this.logger.error(message);
  }

  public debug(message: any) { // Removed callback parameter
    this.logger.debug(message);
  }
}
