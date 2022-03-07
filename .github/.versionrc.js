const branchChannels = {
    "([0-9])?(.{+([0-9]),x}).x": null,
    main: null,
    next: "next",
};

const branch = require("child_process")
    .execSync("git branch --show-current")
    .toString()
    .replace(/\s/g, "");
const branchKey = Object.keys(branchChannels).find((value) =>
    new RegExp(value).test(branch)
);
const channel = branchKey
    ? branchChannels[branchKey]
    : branch.replace("/", "-");

require("fs").copyFileSync(".env.example", ".env");
require("fs").writeFileSync("VERSION", "");
require("fs").writeFileSync("CHANNEL", channel || "latest");

module.exports = {
    tagPrefix: "",
    packageFiles: [],
    infile: "CHANGELOG",
    prerelease: channel,
    bumpFiles: [
        {
            filename: "VERSION",
            updater: {
                readVersion: () => null,
                writeVersion: (_, version) => {
                    return version;
                },
            },
        },
    ],
    skip: {
        commit: true,
        tag: true,
    },
};
