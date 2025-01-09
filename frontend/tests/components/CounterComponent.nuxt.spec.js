import { CounterComponent } from '#components'
import { setActivePinia, createPinia } from 'pinia'
import { describe, it, beforeEach, expect } from 'vitest'
import { mountSuspended } from '@nuxt/test-utils/runtime'

describe('CounterComponent.vue', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  it('can mount counter component', async () => {
    const component = await mountSuspended(CounterComponent)
    expect(component.text()).toContain('Eduardo')
    expect(component.text()).toContain('0')
  })

  it('increments count on button click', async () => {
    const component = await mountSuspended(CounterComponent)
    const button = component.get('button')

    await button.trigger('click')
    expect(component.text()).toContain('2') // doubleCount is displayed

    await button.trigger('click')
    expect(component.text()).toContain('4')
  })
})
