Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3826822F
	for <lists+kvm-ppc@lfdr.de>; Mon, 15 Jul 2019 04:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbfGOCX5 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 14 Jul 2019 22:23:57 -0400
Received: from ozlabs.org ([203.11.71.1]:43431 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbfGOCX5 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sun, 14 Jul 2019 22:23:57 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45n6lv2p8Bz9sP0;
        Mon, 15 Jul 2019 12:23:55 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, paulus@ozlabs.org
Subject: Re: [PATCH 1/3] KVM: PPC: Book3S HV: Always save guest pmu for guest capable of nesting
In-Reply-To: <1563156110.2145.5.camel@gmail.com>
References: <20190703012022.15644-1-sjitindarsingh@gmail.com> <87lfx2egt4.fsf@concordia.ellerman.id.au> <1563156110.2145.5.camel@gmail.com>
Date:   Mon, 15 Jul 2019 12:23:55 +1000
Message-ID: <87blxw9gsk.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Suraj Jitindar Singh <sjitindarsingh@gmail.com> writes:
> On Sat, 2019-07-13 at 13:47 +1000, Michael Ellerman wrote:
>> Suraj Jitindar Singh <sjitindarsingh@gmail.com> writes:
...
>> > 
>> > Fixes: 95a6432ce903 "KVM: PPC: Book3S HV: Streamlined guest
>> > entry/exit path on P9 for radix guests"
>> 
>> I'm not clear why this and the next commit are marked as fixing the
>> above commit. Wasn't it broken prior to that commit as well?
>
> That was the commit which introduced the entry path which we use for a
> nested guest, the path on which we need to be saving and restoring the
> pmu registers and so where the new code was introduced.

OK, I thought that commit was an unrelated optimisation. Agree that is a
good target if it is the commit that introduced the nested path.

cheers
