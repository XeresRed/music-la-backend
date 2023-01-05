module.exports = ({ env }) => ({
  connection: {
    client: 'postgres',
    connection: {
      host: env('DATABASE_HOST', 'dpg-cemv6a9a6gdkdn51fl1g-a.oregon-postgres.render.com'),
      port: env.int('DATABASE_PORT', 5432),
      database: env('DATABASE_NAME', 'musicla'),
      user: env('DATABASE_USERNAME', 'root'),
      password: env('DATABASE_PASSWORD', 'mW52vZLr8JQNnyAlsluPQ2YzZXEed7ra'),
      ssl: env.bool('DATABASE_SSL', true),
    },
  },
});
