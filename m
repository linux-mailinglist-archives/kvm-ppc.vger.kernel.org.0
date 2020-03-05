Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5703A17A48B
	for <lists+kvm-ppc@lfdr.de>; Thu,  5 Mar 2020 12:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgCELsC (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 5 Mar 2020 06:48:02 -0500
Received: from 12.mo7.mail-out.ovh.net ([178.33.107.167]:60207 "EHLO
        12.mo7.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgCELsC (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 5 Mar 2020 06:48:02 -0500
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Mar 2020 06:48:01 EST
Received: from player762.ha.ovh.net (unknown [10.108.42.23])
        by mo7.mail-out.ovh.net (Postfix) with ESMTP id D5C141574EC
        for <kvm-ppc@vger.kernel.org>; Thu,  5 Mar 2020 12:41:59 +0100 (CET)
Received: from kaod.org (82-64-250-170.subs.proxad.net [82.64.250.170])
        (Authenticated sender: clg@kaod.org)
        by player762.ha.ovh.net (Postfix) with ESMTPSA id 2E8F8101583C6;
        Thu,  5 Mar 2020 11:41:34 +0000 (UTC)
Subject: Re: [RFC PATCH v1] powerpc/prom_init: disable XIVE in Secure VM.
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
 <6f7ea308-3505-6070-dde1-20fee8fdddc3@kaod.org>
 <20200303202918.GC5416@oc0525413822.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <950f5c11-07f6-56b9-db8d-e5fd6fa7ab26@kaod.org>
Date:   Thu, 5 Mar 2020 12:41:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200303202918.GC5416@oc0525413822.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 16539188159339400089
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedugedruddutddgfeefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepuffvfhfhkffffgggjggtgfesthejredttdefjeenucfhrhhomhepveorughrihgtpgfnvggpifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucfkpheptddrtddrtddrtddpkedvrdeigedrvdehtddrudejtdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrhejiedvrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheptghlgheskhgrohgurdhorhhgpdhrtghpthhtohepkhhvmhdqphhptgesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

[ ... ] 

>> yes because you also need to share the XIVE TIMA and ESB pages mapped 
>> in xive_native_esb_fault() and xive_native_tima_fault(). 
> 
> These pages belong to the xive memory slot right? If that is the case,
> they are implicitly shared. The Ultravisor will set them up to be
> shared. The guest kernel should not be doing anything.
> 
> We still need some fixes in KVM and Ultravisor to correctly map the
> hardware pages to GPA ranges of the xive memory slot. Work is in progress...

ok. Since this is already done for KVM, I suppose it's not too hard. 
the VMA has VM_IO | VM_PFNMAP flags.

Otherwise you could still pick up the XIVE ESB and TIMA HW MMIO ranges 
in OPAL and brutally declare the whole as shared, if that's possible.

C.
