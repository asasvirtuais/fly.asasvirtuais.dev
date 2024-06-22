import { App } from '@tinyhttp/app'

const app = new App()

const server = app
  .get('/', (_, res) => void res.send('<h1>Hello World</h1>'))
  .listen(3000, () => console.log('Server is running on http://localhost:3000'))
