//
//  main.swift
//  WorldBankDataReader
//
//  Created by doxie on 12/25/19.
//  Copyright © 2019 Xie. All rights reserved.
//

import Foundation

let dataFolder = "/Users/xie/Desktop/Github/DynamicVision/WorldBankData/"



func readCSV(path: String, yearIndex: Int, dataHeader: [String], blackList:[String]) -> NSArray {
    if FileManager.default.fileExists(atPath: path) == true {
        do {
            let fileContent = try String.init(contentsOfFile: path, encoding: .utf8)
            let fileLines = fileContent.components(separatedBy: CharacterSet.init(charactersIn: "\r\n"))
            let contents = NSMutableArray()
            var length: Int = 0
            for line in fileLines {
                let array = line.components(separatedBy: CharacterSet.init(charactersIn: "\t"))
                if length == 0 {
                    length = array.count

                } else {
                    if length != array.count {
                        NSLog("Data Error")
                        break
                    }
                }
                contents.add(array)
            }
            let results = NSMutableArray()
            let headerLine = contents.firstObject as! NSArray
            results.add(dataHeader)
            for i in 1..<contents.count {
                if let contentI = contents[i] as? Array<String> {
                    let countryCode = contentI[1] as String
                    if blackList.contains(countryCode) {
                        continue
                    }

                    let line = NSMutableArray()
                    line.add(contentI[0])
                    print(line)
                    for k in yearIndex..<length {
                        let newLine = NSMutableArray.init(array: line)
                        var data = contentI[k]
                        if data == "" {
                            continue
                        }
                        newLine.add(data)
                        let year = headerLine[k] as! String
                        newLine.add(year)
                        results.add(newLine)
                    }
                }
            }

            return results

        } catch {
            NSLog("%@ can not be read", path)
            return []
        }
    } else {
        NSLog("%@ not exist", path)
        return []
    }
}

func writeCSV(input: NSArray, outPutPath: String) {
    var resultStr: String = ""
    for case let line as NSArray in input {
        let lineContent = line.componentsJoined(by: ",")
        resultStr += lineContent
        resultStr += "\r\n"
    }
    do {
        try resultStr.write(toFile: outPutPath, atomically: true, encoding: .utf8)
    } catch {
        
    }
}


let notCountries = ["ARB", "CEB", "CSS", "EAP", "EAR", "EAS", "ECA", "ECS", "EMU", "EUU", "FCS", "HIC", "HPC", "IBD", "IBT", "IDA", "IDB", "IDX", "INX", "LAC", "LCN", "LDC", "LIC", "LMC", "LMY", "LTE", "MEA", "MIC", "MNA", "NAC", "OED", "OSS", "PRE", "PSS", "PST",
                    "SAS", "SSA", "SSF", "SST", "TEA", "TEC", "TLA", "TMN", "TSA", "TSS", "UMC", "WLD"]
let header = ["name","value","date"]

func generateResult(name: String, blacLlist: [String] = notCountries) {
    let path = dataFolder + name + "/" + name + ".csv"
    let outPutPath = dataFolder + name + "/" + "result.csv"
    writeCSV(input: readCSV(path: path, yearIndex: 4, dataHeader: header, blackList: blacLlist), outPutPath: outPutPath)
}

generateResult(name: "总储备(包括黄金,按现值美元)")



