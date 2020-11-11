const defaultOptions = {
  cache: "no-cache",
  headers: { "Content-Type": "application/json" },
};

const throwIfError = (response) => {
  if (response.error) {
    throw { error: response.error };
  }
  return response;
};

export default {
  request: {
    get: async function (url) {
      return fetch(url)
        .then((response) => response.json())
        .then((response) => throwIfError(response));
    },
    post: async function (url, data = {}) {
      return fetch(url, {
        ...defaultOptions,
        method: "POST",
        body: JSON.stringify(data),
      })
        .then((response) => response.json())
        .then((response) => throwIfError(response));
    },
    put: async function (url, data = {}) {
      return fetch(url, {
        ...defaultOptions,
        method: "PUT",
        body: JSON.stringify(data),
      })
        .then((response) => response.json())
        .then((response) => throwIfError(response));
    },
    delete: async function (url) {
      return fetch(url, {
        ...defaultOptions,
        method: "DELETE",
      });
    },
    upload: async function (url, data) {
      return fetch(url, {
        method: "POST",
        body: data,
      })
        .then((response) => response.json())
        .then((response) => throwIfError(response));
    },
  },
};
