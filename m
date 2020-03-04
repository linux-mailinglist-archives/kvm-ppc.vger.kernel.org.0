Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3AD178F25
	for <lists+kvm-ppc@lfdr.de>; Wed,  4 Mar 2020 12:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387626AbgCDLB5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm-ppc@lfdr.de>); Wed, 4 Mar 2020 06:01:57 -0500
Received: from 10.mo4.mail-out.ovh.net ([188.165.33.109]:54831 "EHLO
        10.mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387851AbgCDLB5 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 4 Mar 2020 06:01:57 -0500
X-Greylist: delayed 8812 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Mar 2020 06:01:56 EST
Received: from player779.ha.ovh.net (unknown [10.110.208.183])
        by mo4.mail-out.ovh.net (Postfix) with ESMTP id 42A1B229104
        for <kvm-ppc@vger.kernel.org>; Wed,  4 Mar 2020 09:35:03 +0100 (CET)
Received: from kaod.org (lns-bzn-46-82-253-208-248.adsl.proxad.net [82.253.208.248])
        (Authenticated sender: groug@kaod.org)
        by player779.ha.ovh.net (Postfix) with ESMTPSA id CA07E100026BE;
        Wed,  4 Mar 2020 08:34:46 +0000 (UTC)
Date:   Wed, 4 Mar 2020 09:34:44 +0100
From:   Greg Kurz <groug@kaod.org>
To:     =?UTF-8?B?Q8OpZHJpYw==?= Le Goater <clg@kaod.org>
Cc:     Ram Pai <linuxram@us.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        mpe@ellerman.id.au, bauerman@linux.ibm.com, andmike@linux.ibm.com,
        sukadev@linux.vnet.ibm.com, aik@ozlabs.ru, paulus@ozlabs.org
Subject: Re: [EXTERNAL] Re: [RFC PATCH v1] powerpc/prom_init: disable XIVE
 in Secure VM.
Message-ID: <20200304093444.5e524ef6@bahia.home>
In-Reply-To: <a1570b0d-c443-3140-31f0-bddd9f31f54b@kaod.org>
References: <1582962844-26333-1-git-send-email-linuxram@us.ibm.com>
        <20200302233240.GB35885@umbus.fritz.box>
        <8f0c3d41-d1f9-7e6d-276b-b95238715979@fr.ibm.com>
        <20200303170205.GA5416@oc0525413822.ibm.com>
        <20200303184520.632be270@bahia.home>
        <a1570b0d-c443-3140-31f0-bddd9f31f54b@kaod.org>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Ovh-Tracer-Id: 7509189430614727051
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedugedruddtjedguddvtdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvuffkjghfofggtgfgsehtqhertdertdejnecuhfhrohhmpefirhgvghcumfhurhiiuceoghhrohhugheskhgrohgurdhorhhgqeenucfkpheptddrtddrtddrtddpkedvrddvheefrddvtdekrddvgeeknecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepphhlrgihvghrjeejledrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehgrhhouhhgsehkrghougdrohhrghdprhgtphhtthhopehkvhhmqdhpphgtsehvghgvrhdrkhgvrhhnvghlrdhorhhg
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, 3 Mar 2020 20:18:18 +0100
Cédric Le Goater <clg@kaod.org> wrote:

> >> **** BTW: I figured, I dont need this intermin patch to disable xive for
> >> secure VM.  Just doing "svm=on xive=off" on the kernel command line is
> >> sufficient for now. *****
> >>
> > 
> > No it is not. If the hypervisor doesn't propose XIVE (ie. ic-mode=xive
> > on the QEMU command line), the kernel simply ignores "xive=off".
> 

Ah... sorry for the typo... "doesn't propose XICS" of course :)

> If I am correct, with the option ic-mode=xive, the hypervisor will 
> propose only 'xive' in OV5 and not both 'xive' and 'xics'. But the
> result is the same because xive can not be turned off and "xive=off" 
> is ignored.
> 
> Anyway, it's not the most common case of usage of the QEMU command
> like. I think it's OK to use "xive=off" on the kernel command line 
> for now.
> 

Sure, I just wanted to make things clear. Like you said it's a chicken
switch introduced for distro testing. I think it should not be used
to do anything else. If "svm=1" needs to enforce supported.xive == false
as a temporary workaround, it should do it explicitly.

> C.

