import { injectable } from 'inversify';
import * as promClient from 'prom-client';
@injectable()
export class MetricsService {
  private readonly _httpRequestTimer: promClient.Histogram;
  private readonly _register: promClient.Registry;
  constructor() {

    // Create a Registry to register the metrics
    this._register = new promClient.Registry();
    this._register.setDefaultLabels({
      app: 'world-cup-1998-server',
    });
    promClient.collectDefaultMetrics({ register: this._register });

    this._httpRequestTimer = new promClient.Histogram({
      name: 'http_request_duration_ms',
      help: 'Duration of HTTP requests in ms',
      labelNames: ['method', 'route', 'code'],
      // buckets for response time from 0.1ms to 1s
      buckets: [0.1, 5, 15, 50, 100, 200, 300, 400, 500, 1000],
    });

    this._register.registerMetric(this._httpRequestTimer);
  }

  get httpRequestTimer() {
    return this._httpRequestTimer;
  }

  get register() {
    return this._register;
  }

}
