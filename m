Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECFA49AFE1
	for <lists+kvm-ppc@lfdr.de>; Fri, 23 Aug 2019 14:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389100AbfHWMsJ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 23 Aug 2019 08:48:09 -0400
Received: from ozlabs.org ([203.11.71.1]:36759 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732009AbfHWMsJ (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 23 Aug 2019 08:48:09 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46FLm659cnz9s7T;
        Fri, 23 Aug 2019 22:48:06 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Claudio Carvalho <cclaudio@linux.ibm.com>, linuxppc-dev@ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Claudio Carvalho <cclaudio@linux.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>,
        Oliver O'Halloran <oohall@gmail.com>
Subject: Re: [PATCH v2] powerpc/powernv: Add ultravisor message log interface
In-Reply-To: <20190823060654.28842-1-cclaudio@linux.ibm.com>
References: <20190823060654.28842-1-cclaudio@linux.ibm.com>
Date:   Fri, 23 Aug 2019 22:48:03 +1000
Message-ID: <87o90g3v5o.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi Claudio,

Claudio Carvalho <cclaudio@linux.ibm.com> writes:
> Ultravisor (UV) provides an in-memory console which follows the OPAL
> in-memory console structure.
>
> This patch extends the OPAL msglog code to also initialize the UV memory
> console and provide a sysfs interface (uv_msglog) for userspace to view
> the UV message log.
>
> CC: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
> CC: Oliver O'Halloran <oohall@gmail.com>
> Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
> ---
> This patch depends on the "kvmppc: Paravirtualize KVM to support
> ultravisor" patchset submitted by Claudio Carvalho.
> ---
>  arch/powerpc/platforms/powernv/opal-msglog.c | 99 ++++++++++++++------
>  1 file changed, 72 insertions(+), 27 deletions(-)

I think the code changes look mostly OK here.

But I'm not sure about the end result in sysfs.

If I'm reading it right this will create:

 /sys/firmware/opal/uv_msglog

Which I think is a little weird, because the UV is not OPAL.

So I guess I wonder if the file should be created elsewhere to avoid any
confusion and keep things nicely separated.

Possibly /sys/firmware/ultravisor/msglog ?

cheers
