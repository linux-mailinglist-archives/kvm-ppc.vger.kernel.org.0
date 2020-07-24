Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7FFA22C64B
	for <lists+kvm-ppc@lfdr.de>; Fri, 24 Jul 2020 15:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbgGXNY6 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 24 Jul 2020 09:24:58 -0400
Received: from ozlabs.org ([203.11.71.1]:51383 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726764AbgGXNY6 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 24 Jul 2020 09:24:58 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4BCqgV4J65z9sV1; Fri, 24 Jul 2020 23:24:52 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Ingo Molnar <mingo@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Leonardo Bras <leobras.c@gmail.com>,
        Vaibhav Jain <vaibhav@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
In-Reply-To: <20200707004812.190765-1-leobras.c@gmail.com>
References: <20200707004812.190765-1-leobras.c@gmail.com>
Subject: Re: [PATCH 1/1] KVM/PPC: Fix typo on H_DISABLE_AND_GET hcall
Message-Id: <159559697292.1657499.11332603391566688077.b4-ty@ellerman.id.au>
Date:   Fri, 24 Jul 2020 23:24:52 +1000 (AEST)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, 6 Jul 2020 21:48:12 -0300, Leonardo Bras wrote:
> On PAPR+ the hcall() on 0x1B0 is called H_DISABLE_AND_GET, but got
> defined as H_DISABLE_AND_GETC instead.
> 
> This define was introduced with a typo in commit <b13a96cfb055>
> ("[PATCH] powerpc: Extends HCALL interface for InfiniBand usage"), and was
> later used without having the typo noticed.

Applied to powerpc/next.

[1/1] KVM: PPC: Fix typo on H_DISABLE_AND_GET hcall
      https://git.kernel.org/powerpc/c/0f10228c6ff6af36cbb31af35b01f76cdb0b3fc1

cheers
