module.exports = {
  root: true,
  parser: '@typescript-eslint/parser',
  plugins: [
    'react',
    '@typescript-eslint',
  ],
  extends: [
    'eslint:recommended',
    'plugin:react/recommended',
    'plugin:@typescript-eslint/eslint-recommended',
    'plugin:@typescript-eslint/recommended',
  ],
  env: {
    browser: true,
    node: true,
    es2020: true
  },
  ecmaFeatures: {
    jsx: true
  },
  rules: {
    semi: 0,
    "space-before-blocks": [1, { "functions": "always", "keywords": "always" }],

    //typescript
    "@typescript-eslint/explicit-function-return-type": 0,
    "@typescript-eslint/member-delimiter-style": [1, {
      multiline: {
        delimiter: 'none',
        requireLast: false
      }
    }],
    "@typescript-eslint/interface-name-prefix": [1, { "prefixWithI": "always" }],
    "space-before-function-paren": 0,
    "@typescript-eslint/space-before-function-paren": [1, "never"],

    //react
    "react/prop-types": 0,
  }
};
