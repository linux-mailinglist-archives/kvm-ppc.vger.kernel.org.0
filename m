Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B41B18575
	for <lists+kvm-ppc@lfdr.de>; Thu,  9 May 2019 08:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfEIGej (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 9 May 2019 02:34:39 -0400
Received: from 14.mo7.mail-out.ovh.net ([178.33.251.19]:41314 "EHLO
        14.mo7.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbfEIGej (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 9 May 2019 02:34:39 -0400
Received: from player772.ha.ovh.net (unknown [10.108.54.38])
        by mo7.mail-out.ovh.net (Postfix) with ESMTP id 565DA11328A
        for <kvm-ppc@vger.kernel.org>; Thu,  9 May 2019 08:34:37 +0200 (CEST)
Received: from kaod.org (lfbn-1-10649-41.w90-89.abo.wanadoo.fr [90.89.235.41])
        (Authenticated sender: clg@kaod.org)
        by player772.ha.ovh.net (Postfix) with ESMTPSA id 2D78A586DDA2;
        Thu,  9 May 2019 06:34:30 +0000 (UTC)
Subject: Re: [PATCH v5 00/16] KVM: PPC: Book3S HV: add XIVE native
 exploitation mode
To:     Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>
References: <20190410170448.3923-1-clg@kaod.org>
 <20190429080506.GA9070@sathnaga86.in.ibm.com>
 <827f230f-1b56-db89-be21-1b2dbd44ef08@kaod.org>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <b8f9f7d1-087d-fa74-b834-fd57ad03adf4@kaod.org>
Date:   Thu, 9 May 2019 08:34:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <827f230f-1b56-db89-be21-1b2dbd44ef08@kaod.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 14554789574445534182
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrkeeggddutdekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


Satheesh,

>> Xive(both ic-mode=dual and ic-mode=xive) guest fails to boot with 
>> guest memory > 64G, till 64G it boots fine.
>>
>> Note: xics(ic-mode=xics) guest with the same configuration boots fine
> 
> Indeed. The guest hangs because IPIs are not correctly received. The guest 
> sees the EQ page as being filled with zeroes and discards the interrupt 
> whereas the host, KVM and QEMU, sees the correct entries.
> 
> I haven't spotted anything bizarre from guest side. Do we have a 64GB 
> frontier somewhere in KVM ? 

The issue was an erroneous assignment of the EQ page address in QEMU.

I pushed the fix in my QEMU branch : 

  https://github.com/legoater/qemu/commits/xive-next

Thanks,

C.
