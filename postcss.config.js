module.exports = (ctx) => ({
  'no-map': true,
  plugins: {
    'postcss-easy-import': {},
    'postcss-cssnext': {
      browsers: ['> 5%', 'not IE < 11'],
      features: {
        autoprefixer: {
          cascade: false,
          flexbox: "no-2009",
          grid: false
        }
      }
    },
    'css-mqpacker': {},
    'cssnano': ctx.env === 'production' ? { autoprefixer: false } : false,
    'postcss-reporter': {}
  }
})
