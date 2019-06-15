Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6787D46EBC
	for <lists+kvm-ppc@lfdr.de>; Sat, 15 Jun 2019 09:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbfFOHh3 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 15 Jun 2019 03:37:29 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:37585 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbfFOHh3 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sat, 15 Jun 2019 03:37:29 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 45Qq7W3GGlz9sNC; Sat, 15 Jun 2019 17:37:27 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1560584247; bh=RQlS/YGl7nl7lg0dX0YZ7lSdRdKWpVUbXN2p5z5araU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=djIhF63m3QNctERvE6C8SBA6S0u9kwKsIumUdSt9KnspzrRoXYUWCTqbGw5Fx7foE
         uNyUbSvGNusuJthv6pcc/S66S7eMsdMqFl/260/R2jCUtEa5HRAyN6vAlzt69BObgh
         VYwNTfIgsXYdrVHMksanL8yia/D9AxmPf4g2vgwTvsWhpMjeU70H+8eGZEPudB+t5c
         jykWUsD7zbrqchNFuIUBqacPOtm1ui47TqBbTwq79rC25+13+HKhnWhuMS6ecPH7o3
         0+brV8YdRA7NOjp1fTGBnerJrpBBnChWIMU5xasM6w7tSFDgMuW+17Z/P/nO1vHS55
         nNTIeOAF+QdMA==
Date:   Sat, 15 Jun 2019 17:36:00 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Claudio Carvalho <cclaudio@linux.ibm.com>
Cc:     linuxppc-dev@ozlabs.org, kvm-ppc@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thiago Bauermann <bauermann@linux.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 3/9] powerpc: Introduce FW_FEATURE_ULTRAVISOR
Message-ID: <20190615073600.GA24709@blackberry>
References: <20190606173614.32090-1-cclaudio@linux.ibm.com>
 <20190606173614.32090-4-cclaudio@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606173614.32090-4-cclaudio@linux.ibm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Jun 06, 2019 at 02:36:08PM -0300, Claudio Carvalho wrote:
> This feature tells if the ultravisor firmware is available to handle
> ucalls.

Everything in this patch that depends on CONFIG_PPC_UV should just
depend on CONFIG_PPC_POWERNV instead.  The reason is that every host
kernel needs to be able to do the ultracall to set partition table
entry 0, in case it ends up being run on a machine with an ultravisor.
Otherwise we will have the situation where a host kernel may crash
early in boot just because the machine it's booted on happens to have
an ultravisor running.  The crash will be a particularly nasty one
because it will happen before we have probed the machine type and
initialized the console; therefore it will just look like the machine
hangs for no discernable reason.

We also need to think about how to provide a way for petitboot to know
whether the kernel it is booting knows how to do a ucall to set its
partition table entry.  One suggestion would be to modify
vmlinux.lds.S to add a new PT_NOTE entry in the program header of the
binary with (say) a 64-bit doubleword which is a bitmap indicating
capabilities of the binary.  We would define the first bit as
indicating that the kernel knows how to run under an ultravisor.
When running under an ultravisor, petitboot could then look for the
PT_NOTE and the ultravisor-capable bit in it, and if the PT_NOTE is
not there or the bit is zero, put up a dialog warning the user that
the kernel will probably crash early in boot, and asking for explicit
confirmation that the user wants to proceed.

Paul.
