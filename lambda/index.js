// import { double } from './lib.mjs';
// export const handler = async () => {
//   let result = double(6); // 12
//   return result;
// };

const url = "https://aws.amazon.com/";

export const handler = async(event) => {
  try {
    // fetch is available with Node.js 18
    const res = await fetch(url);
    console.log("status", res.status);
    console.log("res", res);

    return {
      statusCode: res.status,
      body: JSON.stringify({
        message: res.toString(),
        event: event
      }),
    }
  }
  catch (e) {
    console.error(e);
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: e,
      }),
    }
  }
};