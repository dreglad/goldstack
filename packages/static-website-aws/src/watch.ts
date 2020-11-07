#!/usr/bin/env node

import { init } from './gulp';

const watch = async (args: string[]): Promise<void> => {
  const gulp = await init(args);
  await new Promise((resolve) => {
    gulp.series(['watch'])(resolve);
  });
};

watch(process.argv);
