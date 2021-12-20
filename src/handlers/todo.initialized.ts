import { knativebus } from "knativebus";
import { config } from "../config.js";

const bus = knativebus(config.bus);
const command = "email.send";

export const handle = async (
  request,
  response,
  event,
  { sync = false } = {}
) => {
  const { source, data, type } = event;

  const policyDescription = `When '${type}' then '${command}'`;

  request.log.info({
    msg: `✅ ${policyDescription}`,
    source,
    type,
  });

  // const result = await bus.send(command, data)
  // return response.status(result.status).send();

  return response.status(202).send();
};
