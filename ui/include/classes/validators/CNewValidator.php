<?php
/*
** Zabbix
** Copyright (C) 2001-2021 Zabbix SIA
**
** This program is free software; you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation; either version 2 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program; if not, write to the Free Software
** Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
**/


class CNewValidator {

	private $rules;
	private $input = [];
	private $output = [];
	private $errors = [];
	private $errorsFatal = [];

	/**
	 * Parser for validation rules.
	 *
	 * @var CValidationRule
	 */
	private $validationRuleParser;

	/**
	 * Parser for range date/time.
	 *
	 * @var CRangeTimeParser
	 */
	private $range_time_parser;

	/**
	 * A parser for a list of time periods separated by a semicolon.
	 *
	 * @var CTimePeriodsParser
	 */
	private $time_periods_parser;

	public function __construct(array $input, array $rules) {
		$this->input = $input;
		$this->rules = $rules;
		$this->validationRuleParser = new CValidationRule();

		$this->validate();
	}

	/**
	 * Returns true if the given $value is valid, or set's an error and returns false otherwise.
	 */
	private function validate() {
		foreach ($this->rules as $field => $rule) {
			$result = $this->validateField($field, $rule);

			if (array_key_exists($field, $this->input)) {
				$this->output[$field] = $this->input[$field];
			}
		}
	}

	private function validateField($field, $rules) {
		if (false === ($rules = $this->validationRuleParser->parse($rules))) {
			$this->addError(true, $this->validationRuleParser->getError());
			return false;
		}

		$fatal = array_key_exists('fatal', $rules);

		$flags = array_key_exists('flags', $rules) ? $rules['flags'] : 0x00;

		foreach ($rules as $rule => $params) {
			switch ($rule) {
				/*
				 * 'fatal' => true
				 */
				case 'fatal':
					// nothing to do
					break;

				/*
				 * 'not_empty' => true
				 */
				case 'not_empty':
					if (array_key_exists($field, $this->input) && $this->input[$field] === '') {
						$this->addError($fatal,
							_s('Incorrect value for field "%1$s": %2$s.', $field, _('cannot be empty'))
						);
						return false;
					}
					break;

				case 'json':
					if (array_key_exists($field, $this->input)) {
						if (!is_string($this->input[$field]) || json_decode($this->input[$field]) === null) {
							$this->addError($fatal,
								_s('Incorrect value for field "%1$s": %2$s.', $field, _('JSON string is expected'))
							);
							return false;
						}
					}
					break;

				/*
				 * 'in' => array(<values>)
				 */
				case 'in':
					if (array_key_exists($field, $this->input)) {
						if (!is_string($this->input[$field]) || !in_array($this->input[$field], $params)) {
							$this->addError($fatal,
								is_scalar($this->input[$field])
									? _s('Incorrect value "%1$s" for "%2$s" field.', $this->input[$field], $field)
									: _s('Incorrect value for "%1$s" field.', $field)
							);
							return false;
						}
					}
					break;

				case 'int32':
					if (array_key_exists($field, $this->input)) {
						if (!is_string($this->input[$field]) || !self::is_int32($this->input[$field])) {
							$this->addError($fatal,
								is_scalar($this->input[$field])
									? _s('Incorrect value "%1$s" for "%2$s" field.', $this->input[$field], $field)
									: _s('Incorrect value for "%1$s" field.', $field)
							);
							return false;
						}
					}
					break;

				case 'id':
					if (array_key_exists($field, $this->input)) {
						if (!is_string($this->input[$field]) || !self::is_id($this->input[$field])) {
							$this->addError($fatal,
								is_scalar($this->input[$field])
									? _s('Incorrect value "%1$s" for "%2$s" field.', $this->input[$field], $field)
									: _s('Incorrect value for "%1$s" field.', $field)
							);
							return false;
						}
					}
					break;

				/*
				 * 'array_id' => true
				 */
				case 'array_id':
					if (array_key_exists($field, $this->input)) {
						if (!is_array($this->input[$field]) || !$this->is_array_id($this->input[$field])) {
							$this->addError($fatal,
								is_scalar($this->input[$field])
									? _s('Incorrect value "%1$s" for "%2$s" field.', $this->input[$field], $field)
									: _s('Incorrect value for "%1$s" field.', $field)
							);
							return false;
						}
					}
					break;

				/*
				 * 'array' => true
				 */
				case 'array':
					if (array_key_exists($field, $this->input) && !is_array($this->input[$field])) {
						$this->addError($fatal,
							_s('Incorrect value "%1$s" for "%2$s" field.', $this->input[$field], $field)
						);

						return false;
					}
					break;

				/*
				 * 'array_db' => array(
				 *     'table' => <table_name>,
				 *     'field' => <field_name>
				 * )
				 */
				case 'array_db':
					if (array_key_exists($field, $this->input)) {
						if (!is_array($this->input[$field])
								|| !$this->is_array_db($this->input[$field], $params['table'], $params['field'], $flags)
						) {
							$this->addError($fatal,
								is_scalar($this->input[$field])
									? _s('Incorrect value "%1$s" for "%2$s" field.', $this->input[$field], $field)
									: _s('Incorrect value for "%1$s" field.', $field)
							);
							return false;
						}
					}
					break;

				/*
				 * 'ge' => <value>
				 */
				case 'ge':
					if (array_key_exists($field, $this->input)) {
						if (!is_string($this->input[$field]) || !self::is_int32($this->input[$field])
								|| $this->input[$field] < $params) {
							$this->addError($fatal,
								_s('Incorrect value for field "%1$s": %2$s.', $field, _s('value must be no less than "%1$s"', $params))
							);

							return false;
						}
					}
					break;

				/*
				 * 'le' => <value>
				 */
				case 'le':
					if (array_key_exists($field, $this->input)) {
						if (!is_string($this->input[$field]) || !self::is_int32($this->input[$field])
								|| $this->input[$field] > $params) {
							$this->addError($fatal,
								_s('Incorrect value for field "%1$s": %2$s.', $field, _s('value must be no greater than "%1$s"', $params))
							);

							return false;
						}
					}
					break;

				/*
				 * 'db' => array(
				 *     'table' => <table_name>,
				 *     'field' => <field_name>
				 * )
				 */
				case 'db':
					if (array_key_exists($field, $this->input)) {
						if (!$this->is_db($this->input[$field], $params['table'], $params['field'], $flags)) {
							$this->addError($fatal,
								is_scalar($this->input[$field])
									? _s('Incorrect value "%1$s" for "%2$s" field.', $this->input[$field], $field)
									: _s('Incorrect value for "%1$s" field.', $field)
							);
							return false;
						}
					}
					break;

				/*
				 * 'required' => true
				 */
				case 'required':
					if (!array_key_exists($field, $this->input)) {
						$this->addError($fatal, _s('Field "%1$s" is mandatory.', $field));
						return false;
					}
					break;

				/*
				 * 'range_time' => true
				 */
				case 'range_time':
					if (array_key_exists($field, $this->input) && !$this->isRangeTime($this->input[$field])) {
						$this->addError($fatal,
							_s('Incorrect value for field "%1$s": %2$s.', $field, _('a time is expected'))
						);
						return false;
					}
					break;

				/*
				 * 'time_periods' => true
				 */
				case 'time_periods':
					if (array_key_exists($field, $this->input) && !$this->isTimePeriods($this->input[$field])) {
						$this->addError($fatal,
							_s('Incorrect value for field "%1$s": %2$s.', $field, _('a time period is expected'))
						);
						return false;
					}
					break;

				/*
				 * 'time_unit' => true
				 */
				case 'time_unit':
					if (array_key_exists($field, $this->input)) {
						$result = $this->isTimeUnit($this->input[$field], $params);
						if (!$result['is_valid']) {
							$this->addError($fatal,
								_s('Incorrect value for field "%1$s": %2$s.', $field, $result['error'])
							);
							return false;
						}
					}
					break;

				/*
				 * 'rgb' => true
				 */
				case 'rgb':
					if (array_key_exists($field, $this->input) && !$this->isRgb($this->input[$field])) {
						$this->addError($fatal,
							_s('Incorrect value for field "%1$s": %2$s.', $field,
								_('a hexadecimal color code (6 symbols) is expected')
							)
						);
						return false;
					}
					break;

				/*
				 * 'string' => true
				 */
				case 'string':
					if (array_key_exists($field, $this->input) && !is_string($this->input[$field])) {
						$this->addError($fatal,
							_s('Incorrect value for field "%1$s": %2$s.', $field, _('a character string is expected'))
						);
						return false;
					}
					break;

				/*
				 * 'string' => true
				 */
				case 'cuid':
					if (array_key_exists($field, $this->input) && !self::isCuid($this->input[$field])) {
						$this->addError($fatal,
							_s('Incorrect value for field "%1$s": %2$s.', $field, _('CUID is expected'))
						);
						return false;
					}
					break;

				/*
				 * 'flags' => <value1> | <value2> | ... | <valueN>
				 */
				case 'flags':
					break;

				default:
					// the message can be not translated because it is an internal error
					$this->addError($fatal, 'Invalid validation rule "'.$rule.'".');
					return false;
			}
		}

		return true;
	}

	public static function is_id($value) {
		if (!preg_match('/^'.ZBX_PREG_INT.'$/', $value)) {
			return false;
		}

		return (bccomp($value, '0') >= 0 && bccomp($value, ZBX_DB_MAX_ID) <= 0);
	}

	public static function is_int32($value) {
		if (!preg_match('/^'.ZBX_PREG_INT.'$/', $value)) {
			return false;
		}

		return ($value >= ZBX_MIN_INT32 && $value <= ZBX_MAX_INT32);
	}

	public static function is_uint64($value) {
		if (!preg_match('/^'.ZBX_PREG_INT.'$/', $value)) {
			return false;
		}

		return ($value >= 0 && bccomp($value, ZBX_MAX_UINT64) <= 0);
	}

	public static function isCuid($value): bool {
		if (!is_string($value)) {
			return false;
		}

		if (!CCuid::checkLength($value)) {
			return false;
		}

		if (!CCuid::isCuid($value)) {
			return false;
		}

		return true;
	}

	/**
	 * Validate value against DB schema.
	 *
	 * @param array  $field_schema            Array of DB schema.
	 * @param string $field_schema['type']    Type of DB field.
	 * @param string $field_schema['length']  Length of DB field.
	 * @param string $value                   [IN/OUT] IN - input value, OUT - changed value according to flags.
	 * @param int    $flags                   Validation flags.
	 *
	 * @return bool
	 */
	private function check_db_value($field_schema, &$value, $flags) {
		switch ($field_schema['type']) {
			case DB::FIELD_TYPE_ID:
				return self::is_id($value);

			case DB::FIELD_TYPE_INT:
				return self::is_int32($value);

			case DB::FIELD_TYPE_CHAR:
				if ($flags & P_CRLF) {
					$value = CRLFtoLF($value);
				}

				return (mb_strlen($value) <= $field_schema['length']);

			case DB::FIELD_TYPE_NCLOB:
			case DB::FIELD_TYPE_TEXT:
				if ($flags & P_CRLF) {
					$value = CRLFtoLF($value);
				}

				// TODO: check length
				return true;

			default:
				return false;
		}
	}

	private function is_array_id(array $values) {
		foreach ($values as $value) {
			if (!is_string($value) || !self::is_id($value)) {
				return false;
			}
		}

		return true;
	}

	/**
	 * Validate array of string values against DB schema.
	 *
	 * @param array $values  [IN/OUT] IN - input values, OUT - changed values according to flags.
	 * @param string $table  DB table name.
	 * @param string $field  DB field name.
	 * @param int $flags     Validation flags.
	 *
	 * @return bool
	 */
	private function is_array_db(array &$values, $table, $field, $flags) {
		$table_schema = DB::getSchema($table);

		foreach ($values as &$value) {
			if (!is_string($value) || !$this->check_db_value($table_schema['fields'][$field], $value, $flags)) {
				return false;
			}
		}
		unset($value);

		return true;
	}

	/**
	 * Validate a string value against DB schema.
	 *
	 * @param string $value  [IN/OUT] IN - input value, OUT - changed value according to flags.
	 * @param string $table  DB table name.
	 * @param string $field  DB field name.
	 * @param int $flags     Validation flags.
	 *
	 * @return bool
	 */
	private function is_db(&$value, $table, $field, $flags) {
		$table_schema = DB::getSchema($table);

		return (is_string($value) && $this->check_db_value($table_schema['fields'][$field], $value, $flags));
	}

	private function isTimePeriods($value) {
		if ($this->time_periods_parser === null) {
			$this->time_periods_parser = new CTimePeriodsParser(['usermacros' => true]);
		}

		return is_string($value) && $this->time_periods_parser->parse($value) == CParser::PARSE_SUCCESS;
	}

	/**
	 * Validate a configuration value. Use simple interval parser to parse the string, convert to seconds and check
	 * if the value is in between given min and max values. In some cases it's possible to enter 0, or even 0s or 0d.
	 * If the value is incorrect, set an error.
	 *
	 * @param string $value                  Value to parse and validate.
	 * @param bool   $options['with_year']   Set to "true" to allow month and year unit support.
	 * @param bool   $options['allow_zero']  Set to "true" to allow value to be zero.
	 * @param string $options['min']         Lower bound.
	 * @param string $options['max']         Upper bound.
	 *
	 * @return array  An array with parameter 'is_valid' containing validation result. If validation fails, additionally
	 *                returned parameter 'error' containing error message.
	 */
	private function isTimeUnit($value, $params) {
		$simple_interval_parser = new CSimpleIntervalParser(
			array_key_exists('with_year', $params) ? ['with_year' => true] : []
		);
		$value = (string) $value;

		if ($simple_interval_parser->parse($value) == CParser::PARSE_SUCCESS) {
			if (!$params) {
				return ['is_valid' => true];
			}

			if ($value[0] !== '{') {
				$value = timeUnitToSeconds($value,
					array_key_exists('with_year', $params) ? $params['with_year'] : false
				);

				if (array_key_exists('ranges', $params)) {
					$in_range = false;
					$message_ranges = [];

					foreach ($params['ranges'] as $range) {
						if ($range['from'] <= $value && $value <= $range['to']) {
							$in_range = true;
							break;
						}

						$message_ranges[] = ($range['from'] == $range['to'])
							?  $range['from']
							:  $range['from'].'-'.$range['to'];
					}

					if (!$in_range) {
						return [
							'is_valid' => false,
							'error' => _s('value must be one of %1$s', implode(', ', $message_ranges))
						];
					}
				}
			}
		}
		else {
			return ['is_valid' => false, 'error' => _('a time unit is expected')];
		}

		return ['is_valid' => true];
	}

	private function isRangeTime($value) {
		if ($this->range_time_parser === null) {
			$this->range_time_parser = new CRangeTimeParser();
		}

		return is_string($value) && $this->range_time_parser->parse($value) == CParser::PARSE_SUCCESS;
	}

	private function isRgb($value) {
		return is_string($value) && preg_match('/^[A-F0-9]{6}$/', $value);
	}

	/**
	 * Add validation error.
	 *
	 * @return string
	 */
	public function addError($fatal, $error) {
		if ($fatal) {
			$this->errorsFatal[] = $error;
		}
		else {
			$this->errors[] = $error;
		}
	}

	/**
	 * Get valid fields.
	 *
	 * @return array of fields passed validation
	 */
	public function getValidInput() {
		return $this->output;
	}

	/**
	 * Returns array of error messages.
	 *
	 * @return array
	 */
	public function getAllErrors() {
		return array_merge($this->errorsFatal, $this->errors);
	}

	/**
	 * Returns true if validation failed with errors.
	 *
	 * @return bool
	 */
	public function isError() {
		return (bool) $this->errors;
	}

	/**
	 * Returns true if validation failed with fatal errors.
	 *
	 * @return bool
	 */
	public function isErrorFatal() {
		return (bool) $this->errorsFatal;
	}
}
