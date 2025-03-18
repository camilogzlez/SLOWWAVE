const channels = import.meta.glob("./*_channel.js", { eager: true });

// Loop through and execute each channel module
Object.values(channels).forEach((module) => {
  if (typeof module.default === "function") {
    module.default();
  }
});
