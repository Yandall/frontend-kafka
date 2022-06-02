<template>
  <v-row justify="center" align="center">
    <v-col cols="12" sm="8" md="6">
      <v-card>
        <v-card-text>
          <v-form
          ref="form"
          v-model="valid"
          lazy-validation
          >
            <v-text-field
              v-model="quantity"
              label="Cantidad de datos*"
              type="number"
              :rules="[rules.required, rules.min]"
              required
            ></v-text-field>
            <span v-if="successResponse != ''" class="green--text">
              {{ successResponse }}
            </span>
            <br/>
            <span v-if="errorResponse != ''" class="red--text">
              {{ errorResponse }}
            </span>
          </v-form>
        </v-card-text>
        <v-card-actions>
          <v-spacer/>
          <v-btn
            class="mr-4"
            @click="send"
          >
            Enviar
          </v-btn>
          <v-btn
            class="mr-4"
            @click="getMessages"
          >
            Obtener
          </v-btn>
        </v-card-actions>
      </v-card>
      <br/>
      <v-simple-table>
        <template v-slot:default>
          <thead>
            <tr>
              <th class="text-left">
                Id
              </th>
              <th class="text-left">
                Nombre
              </th>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="(item, index) in messagesList"
              :key="index"
            >
              <td>{{ index + 1 }}</td>
              <td>{{ item }}</td>
            </tr>
          </tbody>
        </template>
      </v-simple-table>
    </v-col>
  </v-row>
</template>

<script>

import random from 'random-name'

export default {
  name: 'IndexPage',
  data () {
    return {
      rules: {
        required: value => !!value || 'Ingrese un valor',
        min: value => value >= 1 || 'El valor debe ser mayor o igual a 1'
      },
      successResponse: '',
      errorResponse: '',
      quantity: 0,
      valid: false,
      messagesList: []
    }
  },

  methods: {

    async send () {
      this.cleanMessages()
      try {
        if (!this.$refs.form.validate()) {
          return
        }
        const url = 'https://kafka-backend.herokuapp.com/mensaje'
        const payload = { messages: `Aquí va una cantidad ${this.quantity}` }
        const { data } = await this.$axios.post(url, payload)
        this.successResponse = data.message
      } catch (error) {
        if (error.response) {
          this.errorResponse = error.response.data.message
        } else {
          this.errorResponse = 'Hubo un error en el servidor'
        }
      }
    },

    generateRandomList (quantity) {
      const list = []
      for (let index = 0; index < quantity; index++) {
        list.push(random())
      }
      return list
    },

    getMessages () {
      this.cleanMessages()
      try {
        // const url = 'https://kafka-backend.herokuapp.com/getMensaje'
        // const { data } = await this.$axios.get(url)
        this.messagesList = this.generateRandomList(this.quantity)
        this.successResponse = 'Lista creada exitosamente'
      } catch (error) {
        if (error.response) {
          this.errorResponse = error.response.data.message
        } else {
          this.errorResponse = 'Hubo un error en el servidor'
        }
      }
    },

    cleanMessages () {
      this.successResponse = ''
      this.errorResponse = ''
    }
  }
}
</script>
