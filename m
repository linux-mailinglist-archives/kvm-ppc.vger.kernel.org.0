Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8F5D19298F
	for <lists+kvm-ppc@lfdr.de>; Wed, 25 Mar 2020 14:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbgCYNYl (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 25 Mar 2020 09:24:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4098 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727027AbgCYNYl (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 25 Mar 2020 09:24:41 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02PDILAN107496;
        Wed, 25 Mar 2020 09:24:26 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ywd8ef53x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Mar 2020 09:24:25 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02PDDKbS006813;
        Wed, 25 Mar 2020 13:24:24 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04wdc.us.ibm.com with ESMTP id 2ywaw91h42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Mar 2020 13:24:24 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02PDOODD45416940
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Mar 2020 13:24:24 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62EF1AE062;
        Wed, 25 Mar 2020 13:24:24 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4256DAE060;
        Wed, 25 Mar 2020 13:24:23 +0000 (GMT)
Received: from localhost (unknown [9.85.139.123])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTPS;
        Wed, 25 Mar 2020 13:24:22 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, paulus@samba.org, linuxram@us.ibm.com
Subject: Re: [PATCH] powerpc/prom_init: Include the termination message in ibm,os-term RTAS call
In-Reply-To: <87zhc4wxy9.fsf@mpe.ellerman.id.au>
References: <20200324201211.1055236-1-farosas@linux.ibm.com> <87zhc4wxy9.fsf@mpe.ellerman.id.au>
Date:   Wed, 25 Mar 2020 10:24:20 -0300
Message-ID: <87sghwh8jf.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_05:2020-03-24,2020-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003250110
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Michael Ellerman <mpe@ellerman.id.au> writes:

> Fabiano Rosas <farosas@linux.ibm.com> writes:
>
>> QEMU can now print the ibm,os-term message[1], so let's include it in
>> the RTAS call. E.g.:
>>
>>   qemu-system-ppc64: OS terminated: Switch to secure mode failed.
>>
>> 1- https://git.qemu.org/?p=qemu.git;a=commitdiff;h=a4c3791ae0
>>
>> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
>> ---
>>  arch/powerpc/kernel/prom_init.c | 3 +++
>>  1 file changed, 3 insertions(+)
>
> I have this queued:
>   https://patchwork.ozlabs.org/patch/1253390/
>
> Which I think does the same thing?
>

Ah, all good then. Nothing to see here... =)

> cheers
>
>> diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
>> index 577345382b23..d543fb6d29c5 100644
>> --- a/arch/powerpc/kernel/prom_init.c
>> +++ b/arch/powerpc/kernel/prom_init.c
>> @@ -1773,6 +1773,9 @@ static void __init prom_rtas_os_term(char *str)
>>  	if (token == 0)
>>  		prom_panic("Could not get token for ibm,os-term\n");
>>  	os_term_args.token = cpu_to_be32(token);
>> +	os_term_args.nargs = cpu_to_be32(1);
>> +	os_term_args.args[0] = cpu_to_be32(__pa(str));
>> +
>>  	prom_rtas_hcall((uint64_t)&os_term_args);
>>  }
>>  #endif /* CONFIG_PPC_SVM */
>> -- 
>> 2.23.0
