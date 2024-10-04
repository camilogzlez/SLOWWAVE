const { environment } = require('@rails/webpacker');

// Check if babel loader exists
const babelLoader = environment.loaders.get('babel');

if (babelLoader) {
  // Ensure the presets are defined and add '@babel/preset-env' if not already included
  const babelLoaderOptions = babelLoader.use.find(item => item.loader === 'babel-loader').options;

  // Initialize presets if undefined
  if (!babelLoaderOptions.presets) {
    babelLoaderOptions.presets = [];
  }

  // Avoid adding the preset multiple times
  if (!babelLoaderOptions.presets.includes('@babel/preset-env')) {
    babelLoaderOptions.presets.push('@babel/preset-env');
  }

  // Ensure Babel handles dynamic imports
  babelLoaderOptions.plugins = babelLoaderOptions.plugins || [];
  if (!babelLoaderOptions.plugins.includes('@babel/plugin-syntax-dynamic-import')) {
    babelLoaderOptions.plugins.push('@babel/plugin-syntax-dynamic-import');
  }
} else {
  // If the babel loader is not present, add it
  environment.loaders.append('babel', {
    test: /\.js$/,
    exclude: /node_modules/,
    use: {
      loader: 'babel-loader',
      options: {
        presets: ['@babel/preset-env'],
        plugins: ['@babel/plugin-syntax-dynamic-import']
      }
    }
  });
}

module.exports = environment;

