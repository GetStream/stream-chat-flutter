module.exports = {
    plugins: [
        [
            '@docusaurus/plugin-content-docs',
            {
                lastVersion: 'current',
                versions: {
                    current: {
                        label: 'v8'
                    },
                }
            }
        ]
    ]
}
