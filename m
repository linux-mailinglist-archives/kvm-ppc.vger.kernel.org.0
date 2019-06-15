Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60AD446EC0
	for <lists+kvm-ppc@lfdr.de>; Sat, 15 Jun 2019 09:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbfFOHjH (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 15 Jun 2019 03:39:07 -0400
Received: from ozlabs.org ([203.11.71.1]:52695 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbfFOHjH (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sat, 15 Jun 2019 03:39:07 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 45Qq9P1qmmz9sNT; Sat, 15 Jun 2019 17:39:05 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1560584345; bh=jJrBcz383cyzLtbHZTqELCISI6z/er7Ec5RzoNiO7Dg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HVi9H+S4FU54amSAnfO8034hu+3F4tiNGpRBBNBoOw7v3Q90a42Y1pehOKAt3FVII
         Q/wpp360CEBGgZIsjxdBjt2UKNaMkVwUKyxa1ahrBNozA9eAiL8eVBNX6WF2yihPZM
         ENd9Lb1A9MMUyBB5hmOaXfolFATOE+ThKxkr/sdacM4HAj3ZGmNV94m7jFfPkDoThH
         9psc85W25l16pzHjsSzq/9axy74yEARUShhFhkJ3UQONUfN7Wg3WTsFzZ+YGPf+C0k
         eIIZmf6CVciKHJwxhuTepsENsRGkyaAiTlGnoApDxmjIgeoeB6eTOwge8Npq1NSlBv
         JE0Zlpy76P3Wg==
Date:   Sat, 15 Jun 2019 17:38:58 +1000
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
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Ryan Grimm <grimm@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 5/9] KVM: PPC: Ultravisor: Use UV_WRITE_PATE ucall to
 register a PATE
Message-ID: <20190615073858.GC24709@blackberry>
References: <20190606173614.32090-1-cclaudio@linux.ibm.com>
 <20190606173614.32090-6-cclaudio@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606173614.32090-6-cclaudio@linux.ibm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Jun 06, 2019 at 02:36:10PM -0300, Claudio Carvalho wrote:
> From: Michael Anderson <andmike@linux.ibm.com>
> 
> When running under an ultravisor, the ultravisor controls the real
> partition table and has it in secure memory where the hypervisor can't
> access it, and therefore we (the HV) have to do a ucall whenever we want
> to update an entry.
> 
> The HV still keeps a copy of its view of the partition table in normal
> memory so that the nest MMU can access it.
> 
> Both partition tables will have PATE entries for HV and normal virtual
> machines.

As discussed before, all of this should depend only on
CONFIG_PPC_POWERNV.

Paul.
