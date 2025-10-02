export declare class DataFreezingJob {
    private static instance;
    private isRunning;
    private scheduledTimeout;
    static getInstance(): DataFreezingJob;
    start(): void;
    stop(): void;
    private scheduleNextRun;
    runManually(date?: string): Promise<void>;
    private runFreezingJob;
    private freezeScheduleData;
    private getScheduleData;
    private calculateActiveShift;
    private calculatePorterActiveShift;
}
export declare const dataFreezingJob: DataFreezingJob;
//# sourceMappingURL=dataFreezing.d.ts.map