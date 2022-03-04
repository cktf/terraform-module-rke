const branchChannels = {
    "([0-9])?(.{+([0-9]),x}).x": undefined,
    main: undefined,
    next: "next",
};

const currentBranch = require("child_process")
    .execSync("git branch --show-current")
    .toString();
const currentChannel =
    branchChannels[
        Object.keys(branchChannels).find((value) =>
            new RegExp(value).test(currentBranch)
        )
    ];

require("fs").writeFileSync("VERSION", "");
require("fs").writeFileSync("CHANNEL", currentChannel || "latest");
require("fs").copyFileSync(".env.example", ".env");

module.exports = {
    tagPrefix: "",
    packageFiles: [],
    infile: "CHANGELOG",
    prerelease: currentChannel,
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
