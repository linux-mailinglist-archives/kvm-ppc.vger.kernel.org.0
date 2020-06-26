Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDF2F20AB67
	for <lists+kvm-ppc@lfdr.de>; Fri, 26 Jun 2020 06:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbgFZEoH (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 26 Jun 2020 00:44:07 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:33137 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgFZEoH (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 26 Jun 2020 00:44:07 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 49tPRT6R2Mz9sSS; Fri, 26 Jun 2020 14:44:05 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        kvm-ppc@vger.kernel.org, paulus@ozlabs.org
Cc:     linuxppc-dev@lists.ozlabs.org
In-Reply-To: <20200611120159.680284-1-aneesh.kumar@linux.ibm.com>
References: <20200611120159.680284-1-aneesh.kumar@linux.ibm.com>
Subject: Re: [PATCH] powerpc/kvm/book3s64/nested: Fix kernel crash with nested kvm
Message-Id: <159314666257.1149515.13073891259313686170.b4-ty@ellerman.id.au>
Date:   Fri, 26 Jun 2020 14:44:05 +1000 (AEST)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, 11 Jun 2020 17:31:59 +0530, Aneesh Kumar K.V wrote:
> __pa() do check for addr value passed and if < PAGE_OFFSET
> results in BUG.
> 
>  #define __pa(x)								\
> ({									\
> 	VIRTUAL_BUG_ON((unsigned long)(x) < PAGE_OFFSET);		\
> 	(unsigned long)(x) & 0x0fffffffffffffffUL;			\
> })
> 
> [...]

Applied to powerpc/fixes.

[1/1] powerpc/kvm/book3s64: Fix kernel crash with nested kvm & DEBUG_VIRTUAL
      https://git.kernel.org/powerpc/c/c1ed1754f271f6b7acb1bfdc8cfb62220fbed423

cheers
