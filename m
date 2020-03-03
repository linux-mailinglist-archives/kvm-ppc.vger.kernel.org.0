Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E23C178337
	for <lists+kvm-ppc@lfdr.de>; Tue,  3 Mar 2020 20:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731015AbgCCThn (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 3 Mar 2020 14:37:43 -0500
Received: from 9.mo177.mail-out.ovh.net ([46.105.72.238]:46569 "EHLO
        9.mo177.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728776AbgCCThn (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 3 Mar 2020 14:37:43 -0500
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Mar 2020 14:37:43 EST
Received: from player799.ha.ovh.net (unknown [10.108.42.102])
        by mo177.mail-out.ovh.net (Postfix) with ESMTP id 70E17123AD6
        for <kvm-ppc@vger.kernel.org>; Tue,  3 Mar 2020 20:18:35 +0100 (CET)
Received: from kaod.org (82-64-250-170.subs.proxad.net [82.64.250.170])
        (Authenticated sender: clg@kaod.org)
        by player799.ha.ovh.net (Postfix) with ESMTPSA id E981A1008C8C7;
        Tue,  3 Mar 2020 19:18:18 +0000 (UTC)
Subject: Re: [EXTERNAL] Re: [RFC PATCH v1] powerpc/prom_init: disable XIVE in
 Secure VM.
To:     Greg Kurz <groug@kaod.org>, Ram Pai <linuxram@us.ibm.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        mpe@ellerman.id.au, bauerman@linux.ibm.com, andmike@linux.ibm.com,
        sukadev@linux.vnet.ibm.com, aik@ozlabs.ru, paulus@ozlabs.org
References: <1582962844-26333-1-git-send-email-linuxram@us.ibm.com>
 <20200302233240.GB35885@umbus.fritz.box>
 <8f0c3d41-d1f9-7e6d-276b-b95238715979@fr.ibm.com>
 <20200303170205.GA5416@oc0525413822.ibm.com>
 <20200303184520.632be270@bahia.home>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <a1570b0d-c443-3140-31f0-bddd9f31f54b@kaod.org>
Date:   Tue, 3 Mar 2020 20:18:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200303184520.632be270@bahia.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 12505088792497195963
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedugedruddtiedguddviecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefuvfhfhffkffgfgggjtgfgsehtjeertddtfeejnecuhfhrohhmpeevrogurhhitggpnfgvpgfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecukfhppedtrddtrddtrddtpdekvddrieegrddvhedtrddujedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepphhlrgihvghrjeelledrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpegtlhhgsehkrghougdrohhrghdprhgtphhtthhopehkvhhmqdhpphgtsehvghgvrhdrkhgvrhhnvghlrdhorhhg
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

>> **** BTW: I figured, I dont need this intermin patch to disable xive for
>> secure VM.  Just doing "svm=on xive=off" on the kernel command line is
>> sufficient for now. *****
>>
> 
> No it is not. If the hypervisor doesn't propose XIVE (ie. ic-mode=xive
> on the QEMU command line), the kernel simply ignores "xive=off".

If I am correct, with the option ic-mode=xive, the hypervisor will 
propose only 'xive' in OV5 and not both 'xive' and 'xics'. But the
result is the same because xive can not be turned off and "xive=off" 
is ignored.

Anyway, it's not the most common case of usage of the QEMU command
like. I think it's OK to use "xive=off" on the kernel command line 
for now.

C.
