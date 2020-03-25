Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 653B919298E
	for <lists+kvm-ppc@lfdr.de>; Wed, 25 Mar 2020 14:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgCYNY1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm-ppc@lfdr.de>); Wed, 25 Mar 2020 09:24:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11986 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727027AbgCYNY0 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 25 Mar 2020 09:24:26 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02PDAX3j104803
        for <kvm-ppc@vger.kernel.org>; Wed, 25 Mar 2020 09:24:25 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ywf3gbqet-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Wed, 25 Mar 2020 09:24:25 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <linuxram@us.ibm.com>;
        Wed, 25 Mar 2020 13:24:21 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 25 Mar 2020 13:24:19 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02PDOKIU41680956
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Mar 2020 13:24:20 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7D4542045;
        Wed, 25 Mar 2020 13:24:20 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B88842049;
        Wed, 25 Mar 2020 13:24:19 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.85.174.15])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 25 Mar 2020 13:24:19 +0000 (GMT)
Date:   Wed, 25 Mar 2020 06:24:16 -0700
From:   Ram Pai <linuxram@us.ibm.com>
To:     Fabiano Rosas <farosas@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        mpe@ellerman.id.au, paulus@samba.org
Subject: Re: [PATCH] powerpc/prom_init: Include the termination message in
 ibm,os-term RTAS call
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20200324201211.1055236-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200324201211.1055236-1-farosas@linux.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 20032513-0012-0000-0000-000003977DB1
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032513-0013-0000-0000-000021D475CC
Message-Id: <20200325132416.GA6257@oc0525413822.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_05:2020-03-24,2020-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999 impostorscore=0
 bulkscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003250105
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Mar 24, 2020 at 05:12:11PM -0300, Fabiano Rosas wrote:
> QEMU can now print the ibm,os-term message[1], so let's include it in
> the RTAS call. E.g.:
> 
>   qemu-system-ppc64: OS terminated: Switch to secure mode failed.
> 
> 1- https://git.qemu.org/?p=qemu.git;a=commitdiff;h=a4c3791ae0
> 
> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
> ---
>  arch/powerpc/kernel/prom_init.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
> index 577345382b23..d543fb6d29c5 100644
> --- a/arch/powerpc/kernel/prom_init.c
> +++ b/arch/powerpc/kernel/prom_init.c
> @@ -1773,6 +1773,9 @@ static void __init prom_rtas_os_term(char *str)
>  	if (token == 0)
>  		prom_panic("Could not get token for ibm,os-term\n");
>  	os_term_args.token = cpu_to_be32(token);
> +	os_term_args.nargs = cpu_to_be32(1);
> +	os_term_args.args[0] = cpu_to_be32(__pa(str));
> +

Reviewed-by: Ram Pai <linuxram@us.ibm.com>

RP

