Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3758E3A8D28
	for <lists+kvm-ppc@lfdr.de>; Wed, 16 Jun 2021 02:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbhFPAFV (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 15 Jun 2021 20:05:21 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:59133 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229811AbhFPAFU (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 15 Jun 2021 20:05:20 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4G4QPY3GL1z9sRf;
        Wed, 16 Jun 2021 10:03:13 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1623801794;
        bh=KmCcyhOsKNECgzYxI+K5ya4vSQmMsByh3se6X2pbJxM=;
        h=From:To:Subject:In-Reply-To:References:Date:From;
        b=rG6PucE0qnbHJUQsvwl61MI2R9+EKUsLHuXThKkh4sR+mivSWBIX8eHcWOAIVQeAV
         hYq5tfNwGZcoeUxw5jEemyogZ5jTLz3BqeMacEF57e6N4c69y0NQ3iaF+wkY9xRLd5
         TM5DHyfPwavFJvWg/0fnbiPmU8iQSo+IY+Fmkm1q0FPI/0MT2rk6WHol+cMCjKU82j
         dZ7/+M1HXINretSGpODV3QZ2TRBg71n1msiqCqEBL6ZKOmMgpQFOTKjaftIkloyCki
         d8evTzOeecYjGmj/qYcDi+DIGb3LF7S2ftniv3ZqxUnit0MHeAEQv3x1pR61hc2T/f
         DvyjZYQDftt/g==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Fabiano Rosas <farosas@linux.ibm.com>,
        Pratik Sampat <psampat@linux.ibm.com>,
        benh@kernel.crashing.org, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org, pratik.r.sampat@gmail.com
Subject: Re: [RFC] powerpc/pseries: Interface to represent PAPR firmware
 attributes
In-Reply-To: <87tum6vb58.fsf@linux.ibm.com>
References: <20210604163501.51511-1-psampat@linux.ibm.com>
 <87wnr4uhs9.fsf@linux.ibm.com>
 <5c9cb57b-e9d8-0361-8be7-60dc9618db34@linux.ibm.com>
 <87tum6vb58.fsf@linux.ibm.com>
Date:   Wed, 16 Jun 2021 10:03:11 +1000
Message-ID: <875yyeu14w.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Fabiano Rosas <farosas@linux.ibm.com> writes:
> Pratik Sampat <psampat@linux.ibm.com> writes:
...
>>>
>>>> The new H_CALL exports information in direct string value format, hence
>>>> a new interface has been introduced in /sys/firmware/papr to export
>>> Hm.. Maybe this should be something less generic than "papr"?
>>
>> The interface naming was inspired from /sys/firmware/opal's naming convention.
>> We believed the name PAPR could serve as more generic name to be used by both
>> Linux running on PHYP and linux on KVM.
>
> Right, I agree with that rationale, but /opal has identifiable elements
> in it whereas /papr would have the generic "attr_X_name", which does not
> give much hint about what they are.
>
> We also expect people to iterate the "attr_X_*" files, so if we decide
> to add something else under /papr in the future, that would potentially
> cause issues with any tool that just lists the content of the directory.
>
> So maybe we should be proactive and put the hcall stuff inside a
> subdirectory already. /papr/energy_scale_attrs comes to mind, but I
> don't have a strong opinion on the particular name.

Maybe we should use the descriptive part of the hcall.

So H_GET_ENERGY_SCALE_INFO -> ../papr/energy_scale_info/

That should help avoid any naming confusion, because every hcall should
have a unique name.

In future if there's ever a H_GET_ENERGY_SCALE_INFO_2 we would then have
to decide if we expose that as a separate directory, or more likely we
would handle that in the kernel and continue to use the existing sysfs
name.

...

> Based on all the new information you provided, I'd say present all the
> data and group it under the ID:
>
> /sys/firmware/papr/energy_scale_attrs/
>    |-- <id>/
>      |-- desc
>      |-- value
>      |-- value_desc
>    |-- <id>/
>      |-- desc
>      |-- value
>      |-- value_desc

Yeah that seems reasonable.

I'd think we should just omit the value_desc if it's empty.

cheers
