Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A653175A55
	for <lists+kvm-ppc@lfdr.de>; Mon,  2 Mar 2020 13:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbgCBMUT (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 2 Mar 2020 07:20:19 -0500
Received: from 8.mo68.mail-out.ovh.net ([46.105.74.219]:39521 "EHLO
        8.mo68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727361AbgCBMUT (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 2 Mar 2020 07:20:19 -0500
X-Greylist: delayed 16791 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Mar 2020 07:20:18 EST
Received: from player695.ha.ovh.net (unknown [10.108.42.167])
        by mo68.mail-out.ovh.net (Postfix) with ESMTP id B1A911572ED
        for <kvm-ppc@vger.kernel.org>; Mon,  2 Mar 2020 08:35:06 +0100 (CET)
Received: from kaod.org (82-64-250-170.subs.proxad.net [82.64.250.170])
        (Authenticated sender: clg@kaod.org)
        by player695.ha.ovh.net (Postfix) with ESMTPSA id B103DFD08FC4;
        Mon,  2 Mar 2020 07:34:51 +0000 (UTC)
Subject: Re: [RFC PATCH v1] powerpc/prom_init: disable XIVE in Secure VM.
To:     Ram Pai <linuxram@us.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        aik@ozlabs.ru, andmike@linux.ibm.com, groug@kaod.org,
        clg@fr.ibm.com, sukadev@linux.vnet.ibm.com, bauerman@linux.ibm.com,
        david@gibson.dropbear.id.au
References: <1582962844-26333-1-git-send-email-linuxram@us.ibm.com>
 <1e28fb80-7bae-8d80-1a72-f616af030aab@kaod.org>
 <20200229225140.GA5618@oc0525413822.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <d1ff5c06-f0a9-981e-53bc-0030c3312d55@kaod.org>
Date:   Mon, 2 Mar 2020 08:34:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200229225140.GA5618@oc0525413822.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 13198361662201170918
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedugedruddtfedgudduudcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecunecujfgurhepuffvfhfhkffffgggjggtgfesthekredttdefjeenucfhrhhomhepveorughrihgtpgfnvggpifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucfkpheptddrtddrtddrtddpkedvrdeigedrvdehtddrudejtdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrheileehrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheptghlgheskhgrohgurdhorhhgpdhrtghpthhtohepkhhvmhdqphhptgesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 2/29/20 11:51 PM, Ram Pai wrote:
> On Sat, Feb 29, 2020 at 09:27:54AM +0100, Cédric Le Goater wrote:
>> On 2/29/20 8:54 AM, Ram Pai wrote:
>>> XIVE is not correctly enabled for Secure VM in the KVM Hypervisor yet.
>>>
>>> Hence Secure VM, must always default to XICS interrupt controller.
>>
>> have you tried XIVE emulation 'kernel-irqchip=off' ? 
> 
> yes and it hangs. I think that option, continues to enable some variant
> of XIVE in the VM. 

HW is not involved, KVM is not involved anymore and all is emulated at 
the QEMU level in user space. What is the issue ? 

> There are some known deficiencies between KVM
> and the ultravisor negotiation, resulting in a hang in the SVM.

That is something else to investigate. feature/capability negotiation
is the core of the hypervisor stack : 

    OPAL <-> PowerNV <-> KVM <-> QEMU <-> guest OS

>>> If XIVE is requested through kernel command line option "xive=on",
>>> override and turn it off.
>>
>> This is incorrect. It is negotiated through CAS depending on the FW
>> capabilities and the KVM capabilities.
> 
> Yes I understand, qemu/KVM have predetermined a set of capabilties that
> it can offer to the VM.  The kernel within the VM has a list of
> capabilties it needs to operate correctly.  So both negotiate and
> determine something mutually ammicable.
> 
> Here I am talking about the list of capabilities that the kernel is
> trying to determine, it needs to operate correctly.  "xive=on" is one of
> those capabilities the kernel is told by the VM-adminstrator, to enable.

XIVE is not a kernel capability. It's platform support and the default
for P9 is the native exploitation mode which makes full use of the P9
interrupt controller. For non XIVE aware kernels, the hypervisor emulates
the legacy interface on top of XIVE. 

"xive=off" was introduced for distro testing. It skips the negotiation 
process of the XIVE native exploitation mode on the guest. But it's not
a negotiation setting. It's a chicken switch.

> Unfortunately if the VM-administrtor blindly requests to enable it, the
> kernel must override it, if it knows that will be switching the VM into
> a SVM soon. No point negotiating a capability with Qemu; through CAS,
> if it knows it cannot handle that capability.

I don't understand. Are you talking about SVM or XIVE ? 

>>> If XIVE is the only supported platform interrupt controller; specified
>>> through qemu option "ic-mode=xive", simply abort. Otherwise default to
>>> XICS.
>>
>>
>> I don't think it is a good approach to downgrade the guest kernel 
>> capabilities this way. 
>>
>> PAPR has specified the CAS negotiation process for this purpose. It 
>> comes in two parts under KVM. First the KVM hypervisor advertises or 
>> not a capability to QEMU. The second is the CAS negotiation process 
>> between QEMU and the guest OS.
> 
> Unfortunately, this is not viable.  At the time the hypervisor
> advertises its capabilities to qemu, the hypervisor has no idea whether
> that VM will switch into a SVM or not. 

OK, but the hypervisor knows if it can handle 'SVM' guests or not and,
if not, there is no point in advertising a 'SVM' capability to the guest. 

> The decision to switch into a> SVM is taken by the kernel running in the VM. This happens much later,
> after the hypervisor has already conveyed its capabilties to the qemu, and
> qemu has than instantiated the VM.

So you don't have negotiation with the hypervisor ? How does the guest
knows the hypervisor platform can handle SVMs ? try and see if it fails ?
If so, it seems quite broken to me.
 
> As a result, CAS in prom_init is the only place where this negotiation
> can take place.

Euh. I don't follow. This is indeed where CAS is performed and so it's 
*the* place to check that the hypervisor has 'SVM' support ? 

>> The SVM specifications might not be complete yet and if some features 
>> are incompatible, I think we should modify the capabilities advertised 
>> by the hypervisor : no XIVE in case of SVM. QEMU will automatically 
>> use the fallback path and emulate the XIVE device, same as setting 
>> 'kernel-irqchip=off'. 
> 
> As mentioned above, this would be an excellent approach, if the
> Hypervisor was aware of the VM's intent to switch into a SVM. Neither
> the hypervisor knows, nor the qemu.  Only the kernel running within the
> VM knows about it.


The hypervisor (KVM/QEMU) never knows what are the guest OS capabilities
or its intents. That is why there is a negotiation process. 

I would do :

 * OPAL FW advertises 'SVM' support to the Linux PowerNV (through DT) 
 * KVM advertises 'SVM' support to QEMU (extend KVM ioctls)
 * QEMU advertises 'SVM' support to guest OS (through CAS or DT) 
 * Guest OS should not try to use SVM it is not supported. 

If the passthrough of HW pages is not supported by Ultravisor, KVM 
should not advertised XIVE to QEMU which would then use fallback mode.

If emulated XIVE or XICS is not supported by SVM guests, then we have
a problem and we need to understand why ! :) 

And if XIVE is still a problem, then the guest could change the CAS 
request and remove XIVE when SVM is being set. I suppose that we have 
all this information before CAS. Do we ? 

It should be a runtime choice taking into account the full software 
stack rather than a compile choice at the bottom which would impact
all other options. This is not acceptable IMHO.

Cheers,

C.
