const path = require('path');

module.exports = {
  entry: './app/javascript/packs/application.js', // Entry point
  output: {
    filename: 'application.js',
    path: path.resolve(__dirname, 'public/packs'), // Output directory
    publicPath: '/packs/'
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['@babel/preset-env']
          }
        }
      },
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader'],
      }
    ]
  },
  resolve: {
    extensions: ['.js', '.jsx', '.css'],
    alias: {
      channels: path.resolve(__dirname, 'app/javascript/channels'), // Alias for channels
      controllers: path.resolve(__dirname, 'app/javascript/controllers'), // Alias for controllers
    }
  },
  node: {
    // Polyfill settings for Node.js core modules
    __dirname: false, // Include __dirname in the bundle
    __filename: false, // Include __filename in the bundle
    global: true, // Provide a global variable
    // You can also add specific Node.js modules if needed:
    // dgram: 'empty', // If you don't need this, comment it out
    // fs: 'empty', // If you don't need this, comment it out
    // net: 'empty', // If you don't need this, comment it out
    // tls: 'empty', // If you don't need this, comment it out
    // child_process: 'empty', // If you don't need this, comment it out
  },
  mode: 'production', // Change to 'production' for production builds
};
