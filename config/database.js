module.exports = ({ env }) => ({
  connection: {
    client: 'postgres',
    connection: {
      host: env('DATABASE_HOST', 'postgres_db'),
      port: env.int('DATABASE_PORT', 5432),
      database: env('DATABASE_NAME', 'musicla'),
      user: env('DATABASE_USERNAME', 'root'),
      password: env('DATABASE_PASSWORD', 'pass'),
      ssl: env.bool('DATABASE_SSL', false),
    },
  },
});
