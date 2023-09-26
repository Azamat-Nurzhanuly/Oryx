﻿// --------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.
// --------------------------------------------------------------------------------------------

using System.Collections.Generic;
using System.Linq;

namespace Microsoft.Oryx.Tests.Common
{
    public static class TestValueGenerator
    {
        private readonly static List<(string Version, string OsType)> NodeVersions = new List<(string, string)>
        {
            ("14", ImageTestHelperConstants.OsTypeDebianBuster),
            ("14", ImageTestHelperConstants.OsTypeDebianBullseye),
            ("16", ImageTestHelperConstants.OsTypeDebianBuster),
            ("16", ImageTestHelperConstants.OsTypeDebianBullseye)
        };

        private readonly static List<(string Version, string OsType)> PythonVersions = new List<(string, string)>
        {
            ("3.7", ImageTestHelperConstants.OsTypeDebianBuster),
            ("3.7", ImageTestHelperConstants.OsTypeDebianBullseye),
            ("3.8", ImageTestHelperConstants.OsTypeDebianBuster),
            ("3.8", ImageTestHelperConstants.OsTypeDebianBullseye),
            ("3.9", ImageTestHelperConstants.OsTypeDebianBuster),
            ("3.9", ImageTestHelperConstants.OsTypeDebianBullseye)
        };

        public static IEnumerable<object[]> GetNodeVersions_SupportDebugging()
        {
            var versions = new List<(string Version, string OsType)>
            {
                ("14", ImageTestHelperConstants.OsTypeDebianBuster),
                ("14", ImageTestHelperConstants.OsTypeDebianBullseye),
                ("16", ImageTestHelperConstants.OsTypeDebianBuster),
                ("16", ImageTestHelperConstants.OsTypeDebianBullseye)
            };

            return versions.Select(x => new object[] { x.Version, x.OsType });
        }

        public static IEnumerable<object[]> GetNodeVersions()
        {
            foreach (var x in NodeVersions)
            {
                yield return new object[] { x.Version, x.OsType };
            }
        }
        
        public static IEnumerable<object[]> GetPythonVersions()
        {
            foreach (var x in PythonVersions)
            {
                yield return new object[] { x.Version, x.OsType };
            }
        }

        public static IEnumerable<object[]> GetNodeVersions_SupportPm2()
        {
            return NodeVersions
                .Select(x => new object[] { x.Version, x.OsType });
        }
    }
}