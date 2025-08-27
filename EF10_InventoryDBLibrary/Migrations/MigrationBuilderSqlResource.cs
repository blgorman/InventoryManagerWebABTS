﻿using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Migrations.Operations;
using Microsoft.EntityFrameworkCore.Migrations.Operations.Builders;
using System.Reflection;
using System.Text;
using System.IO;

namespace EF10_InventoryDBLibrary.Migrations;

public static class MigrationBuilderSqlResource
{
    public static OperationBuilder<SqlOperation> SqlResource(this MigrationBuilder mb, string relativeFileName)
    {
        var assembly = Assembly.GetAssembly(typeof(MigrationBuilderSqlResource));
        
        using (var stream = assembly?.GetManifestResourceStream(relativeFileName) ?? throw new FileNotFoundException("Embedded SQL Resource missing"))
        {
            using (var ms = new MemoryStream())
            {
                //get the stream to memory
                stream.CopyTo(ms);

                //Decode without BOM
                var text = new UTF8Encoding(encoderShouldEmitUTF8Identifier: false)
                                .GetString(ms.ToArray());

                //read the file and return the code to execute
                return mb.Sql(text);
            }
        }
    }
}
