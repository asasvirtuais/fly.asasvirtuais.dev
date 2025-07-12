import 'dotenv/config'
import { feathers } from '@feathersjs/feathers'
import { koa, rest, bodyParser, errorHandler, serveStatic } from '@feathersjs/koa'
import socketio from '@feathersjs/socketio'
import airtable from './airtable.js'

const app = koa(feathers())

// Use the public folder for static file hosting
app.use(serveStatic('./public'))
// Register the error handle
app.use(errorHandler())
// Parse JSON request bodies
app.use(bodyParser())
// Register REST service handler
app.configure(rest())
// Configure Socket.io real-time APIs
app.configure(socketio())

const tableService = (tableName: string) => airtable({
  apiKey: process.env.AIRTABLE_TOKEN,
  baseId: 'app6ubrlP9ZC2JqEq',
  tableName,
})

app.use('todos', tableService('Todos'))
app.use('users', tableService('Users'))
app.use('chats', tableService('Chats'))
app.use('messages', tableService('Messages'))
app.use('presets', tableService('Presets'))
.use(
  (context) => {
    const authorization = context.http?.headers?.['authorization'] ?? ''
    if (authorization !== process.env.SUPER_SECRET_KEY)
      throw new Error('Unauthorized')
  }
)

app
  .listen(3000)
  .then(() => console.log('Feathers server listening on localhost:3000'))
