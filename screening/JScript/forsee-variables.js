var fsrSP = 20,
    fsrLF = 3,
    fsrMapping = {
        pattern: /(.*)/i,
        samplingPercentage: 20,
        loyaltyFactor: 3
    },
    currentPageUrl = window.location.href,
    fsrMappings = [];
fsrMappings.push({
    pattern: /\/\/www\.atsdr\.cdc\.gov\/pfas\/(.*)/gi,
    samplingPercentage: 75,
    loyaltyFactor: 2
});
for (var fsrMappingIndex = 0; fsrMappingIndex < fsrMappings.length; fsrMappingIndex++) {
    var mapping = fsrMappings[fsrMappingIndex];
    if ("object" == typeof mapping.pattern) {
        if (mapping.pattern.test(currentPageUrl)) {
            fsrSP = mapping.samplingPercentage, fsrLF = mapping.loyaltyFactor;
            break
        }
    } else if (-1 < currentPageUrl.indexOf(mapping.pattern)) {
        fsrSP = mapping.samplingPercentage, fsrLF = mapping.loyaltyFactor;
        break
    }
}