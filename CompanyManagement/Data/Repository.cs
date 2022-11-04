using System.Data;
using System.Data.SqlClient;

namespace CompanyManagement.Data
{
    public class Repository
    {
        //testString
        private string connectionString = "Server=CompanyServer;Database=Company;Trusted_Connection=True";

        public void CreateDepartment(string DName, string MgrSSN)
        {
            int convertedDNumber = ConvertStringToInt(MgrSSN);
            try
            {
                using (var connection = new SqlConnection(connectionString))
                using (SqlCommand command = new SqlCommand($"usp_CreateDepartment", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add($"DName", SqlDbType.VarChar).Value = DName;
                    command.Parameters.Add($"MgrSSN", SqlDbType.Int).Value = convertedDNumber;

                    command.Parameters.Add("DNumber", SqlDbType.Int);
                    command.Parameters["DNumber"].Direction = ParameterDirection.Output;
                    connection.Open();
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            for (int i = 0; i < reader.FieldCount; i++)
                            {
                                Console.WriteLine("Department created. Number:");
                                Console.WriteLine(reader.GetValue(i));
                            }
                        }
                    }
                }
            }
            catch (SqlException exception)
            {
                Console.WriteLine(exception);
            }
        }

        private int ConvertStringToInt(string inputToConvert)
        {
            int converted = 0;
            try { converted = Int32.Parse(inputToConvert); }
            catch { Console.WriteLine("Input must a be number"); }
            return converted;
        }

        public void UpdateDepartmentName(string DNumber, string DName)
        {
            try
            {
                int convertedDNumber = ConvertStringToInt(DNumber);
                using (var connection = new SqlConnection(connectionString))
                using (SqlCommand command = new SqlCommand($"usp_UpdateCreateDepartment", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add($"DName", SqlDbType.VarChar).Value = DName;
                    command.Parameters.Add($"DNumber", SqlDbType.Int).Value = convertedDNumber;

                    connection.Open();
                    command.ExecuteNonQuery();
                    Console.WriteLine("Department name updated");
                }
            }
            catch (SqlException exception)
            {
                Console.WriteLine(exception);
            }
        }

        public void UpdateDepartmentManager(string DNumber, string MgrSSN)
        {
            try
            {
                int convertedDNumber = ConvertStringToInt(DNumber);
                int convertedSSN = ConvertStringToInt(MgrSSN);
                using (var connection = new SqlConnection(connectionString))
                using (SqlCommand command = new SqlCommand($"usp_UpdateDepartmentManager", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add($"DNumber", SqlDbType.Int).Value = convertedDNumber;
                    command.Parameters.Add($"MgrSSN", SqlDbType.Int).Value = convertedSSN;
                    connection.Open();
                    command.ExecuteNonQuery();
                    Console.WriteLine("Department manager updated");
                }
            }
            catch (SqlException exception)
            {
                Console.WriteLine(exception);
            }
        }

        public void DeleteDepartment(string DNumber)
        {
            try
            {
                int convertedDNumber = ConvertStringToInt(DNumber);
                using (var connection = new SqlConnection(connectionString))
                using (SqlCommand command = new SqlCommand($"usp_DeleteDepartment", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add($"DNumber", SqlDbType.Int).Value = convertedDNumber;
                    connection.Open();
                    command.ExecuteNonQuery();
                    Console.WriteLine("Department deleted");
                }
            }
            catch (SqlException exception)
            {
                Console.WriteLine(exception);
            }
        }

        public void GetDepartment(string DNumber)
        {
            try
            {
                int convertedDNumber = ConvertStringToInt(DNumber);
                using (var connection = new SqlConnection(connectionString))
                using (SqlCommand command = new SqlCommand($"usp_GetDepartment", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add($"DNumber", SqlDbType.Int).Value = convertedDNumber;
                    connection.Open();
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            for (int i = 0; i < reader.FieldCount; i++)
                            {
                                Console.WriteLine(reader.GetValue(i));
                            }
                        }
                    }
                }
            }
            catch (SqlException exception)
            {
                Console.WriteLine(exception);
            }
        }

        public void GetAllDepartments()
        {
            try
            {
                using (var connection = new SqlConnection(connectionString))
                using (SqlCommand command = new SqlCommand($"usp_GetAllDepartment", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    connection.Open();
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            for (int i = 0; i < reader.FieldCount; i++)
                            {
                                Console.WriteLine(reader.GetValue(i));
                            }
                        }
                    }
                }
            }
            catch (SqlException exception)
            {
                Console.WriteLine(exception);
            }
        }
    }
}
