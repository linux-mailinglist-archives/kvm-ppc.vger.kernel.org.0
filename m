Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBA15178321
	for <lists+kvm-ppc@lfdr.de>; Tue,  3 Mar 2020 20:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbgCCT1u (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 3 Mar 2020 14:27:50 -0500
Received: from 8.mo177.mail-out.ovh.net ([46.105.61.98]:38480 "EHLO
        8.mo177.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728787AbgCCT1u (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 3 Mar 2020 14:27:50 -0500
X-Greylist: delayed 604 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Mar 2020 14:27:48 EST
Received: from player729.ha.ovh.net (unknown [10.110.171.96])
        by mo177.mail-out.ovh.net (Postfix) with ESMTP id A3D6D1234FE
        for <kvm-ppc@vger.kernel.org>; Tue,  3 Mar 2020 20:09:10 +0100 (CET)
Received: from kaod.org (82-64-250-170.subs.proxad.net [82.64.250.170])
        (Authenticated sender: clg@kaod.org)
        by player729.ha.ovh.net (Postfix) with ESMTPSA id 87FF910293524;
        Tue,  3 Mar 2020 19:08:54 +0000 (UTC)
Subject: Re: [EXTERNAL] Re: [RFC PATCH v1] powerpc/prom_init: disable XIVE in
 Secure VM.
To:     Ram Pai <linuxram@us.ibm.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        mpe@ellerman.id.au, bauerman@linux.ibm.com, andmike@linux.ibm.com,
        sukadev@linux.vnet.ibm.com, aik@ozlabs.ru, paulus@ozlabs.org,
        groug@kaod.org
References: <1582962844-26333-1-git-send-email-linuxram@us.ibm.com>
 <20200302233240.GB35885@umbus.fritz.box>
 <8f0c3d41-d1f9-7e6d-276b-b95238715979@fr.ibm.com>
 <20200303170205.GA5416@oc0525413822.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <6f7ea308-3505-6070-dde1-20fee8fdddc3@kaod.org>
Date:   Tue, 3 Mar 2020 20:08:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200303170205.GA5416@oc0525413822.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 12346055429023107993
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedugedruddtiedguddvgecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefuvfhfhffkffgfgggjtgfgsehtjeertddtfeejnecuhfhrohhmpeevrogurhhitggpnfgvpgfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecukfhppedtrddtrddtrddtpdekvddrieegrddvhedtrddujedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepphhlrgihvghrjedvledrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpegtlhhgsehkrghougdrohhrghdprhgtphhtthhopehkvhhmqdhpphgtsehvghgvrhdrkhgvrhhnvghlrdhorhhg
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

>>>   4) I'm guessing the problem with XIVE in SVM mode is that XIVE needs
>>>      to write to event queues in guest memory, which would have to be
>>>      explicitly shared for secure mode.  That's true whether it's KVM
>>>      or qemu accessing the guest memory, so kernel_irqchip=on/off is
>>>      entirely irrelevant.
>>
>> This problem should be already fixed.
>> The XIVE event queues are shared 
>  	
> Yes i have a patch for the guest kernel that shares the event 
> queue page with the hypervisor. This is done using the
> UV_SHARE_PAGE ultracall. This patch is not sent out to any any mailing
> lists yet. However the patch by itself does not solve the xive problem
> for secure VM.

yes because you also need to share the XIVE TIMA and ESB pages mapped 
in xive_native_esb_fault() and xive_native_tima_fault(). 

>> and the remaining problem with XIVE is the KVM page fault handler 
>> populating the TIMA and ESB pages. Ultravisor doesn't seem to support
>> this feature and this breaks interrupt management in the guest. 
> 
> Yes. This is the bigger issue that needs to be fixed. When the secure guest
> accesses the page associated with the xive memslot, a page fault is
> generated, which the ultravisor reflects to the hypervisor. Hypervisor
> seems to be mapping Hardware-page to that GPA. Unforatunately it is not
> informing the ultravisor of that map.  I am trying to understand the
> root cause. But since I am not sure what more issues I might run into
> after chasing down that issue, I figured its better to disable xive
> support in SVM in the interim.

Is it possible to call uv_share_page() from the hypervisor ? 

> **** BTW: I figured, I dont need this intermin patch to disable xive for
> secure VM.  Just doing "svm=on xive=off" on the kernel command line is
> sufficient for now. *****

Yes. 

>> But, kernel_irqchip=off should work out of the box. It seems it doesn't. 
>> Something to investigate.
> 
> Dont know why. 

We need to understand why. 

You still need the patch to share the event queue page allocated by the 
guest OS because QEMU will enqueue events. But you should not need anything
else.

> Does this option, disable the chip from interrupting the
> guest directly; instead mediates the interrupt through the hypervisor?

Yes. The KVM backend is unused, the XIVE interrupt controller is deactivated
for the guest and QEMU notifies the vCPUs directly.  

The TIMA and ESB pages belong the QEMU process and the guest OS will do 
some load and store operations onto them for interrupt management. Is that 
OK from a UV perspective ?  

Thanks,

C.
