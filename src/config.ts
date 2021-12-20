export const config = {
  port: parseInt(process.env.PORT || "", 10) || 5020,

  handlerBasePath: process.env.HANDLER_BASE_PATH || "src",

  bus: {
    aggregates: {
      email: {
        commands:
          process.env.EMAIL_COMMANDS_BROKER_URL ||
          "http://broker-ingress.knative-eventing.svc.cluster.local/default/email-commands",
      },
    },
    source: "example-policy-service",
  },
};
