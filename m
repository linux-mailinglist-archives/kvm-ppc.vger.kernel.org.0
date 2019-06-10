Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5605B3B47F
	for <lists+kvm-ppc@lfdr.de>; Mon, 10 Jun 2019 14:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388833AbfFJMSt (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 10 Jun 2019 08:18:49 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42644 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389824AbfFJMSt (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 10 Jun 2019 08:18:49 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5ACDxmO062640
        for <kvm-ppc@vger.kernel.org>; Mon, 10 Jun 2019 08:18:47 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t1mwvp2ak-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Mon, 10 Jun 2019 08:18:47 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <cclaudio@linux.ibm.com>;
        Mon, 10 Jun 2019 13:18:46 +0100
Received: from b03cxnp07028.gho.boulder.ibm.com (9.17.130.15)
        by e31.co.us.ibm.com (192.168.1.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 10 Jun 2019 13:18:44 +0100
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5ACIg6223331120
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jun 2019 12:18:42 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A94CB7805C;
        Mon, 10 Jun 2019 12:18:42 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F9D47805E;
        Mon, 10 Jun 2019 12:18:40 +0000 (GMT)
Received: from [9.18.235.79] (unknown [9.18.235.79])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 10 Jun 2019 12:18:40 +0000 (GMT)
Subject: Re: [PATCH v3 1/9] KVM: PPC: Ultravisor: Add PPC_UV config option
To:     Leonardo Bras <leonardo@linux.ibm.com>, linuxppc-dev@ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
References: <20190606173614.32090-1-cclaudio@linux.ibm.com>
 <20190606173614.32090-2-cclaudio@linux.ibm.com>
 <0f6d278e78b2784a77ce2cd07a84377da6f5262e.camel@linux.ibm.com>
From:   Claudio Carvalho <cclaudio@linux.ibm.com>
Date:   Mon, 10 Jun 2019 09:18:39 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.0
MIME-Version: 1.0
In-Reply-To: <0f6d278e78b2784a77ce2cd07a84377da6f5262e.camel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19061012-8235-0000-0000-00000EA5F1A6
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011242; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01215941; UDB=6.00639292; IPR=6.00997040;
 MB=3.00027252; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-10 12:18:45
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061012-8236-0000-0000-000045F57D3F
Message-Id: <156cd4df-7616-1f34-afd6-7298ebdc8dc0@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-10_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906100086
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


On 6/7/19 5:11 PM, Leonardo Bras wrote:
>
> On Thu, 2019-06-06 at 14:36 -0300, Claudio Carvalho wrote:
>> From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
>>
>> CONFIG_PPC_UV adds support for ultravisor.
>>
>> Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
>> Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>
>> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
>> [Update config help and commit message]
>> Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
>> ---
>>  arch/powerpc/Kconfig | 20 ++++++++++++++++++++
>>  1 file changed, 20 insertions(+)
>>
>> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
>> index 8c1c636308c8..276c1857c335 100644
>> --- a/arch/powerpc/Kconfig
>> +++ b/arch/powerpc/Kconfig
>> @@ -439,6 +439,26 @@ config PPC_TRANSACTIONAL_MEM
>>         ---help---
>>           Support user-mode Transactional Memory on POWERPC.
>>
>> +config PPC_UV
>> +	bool "Ultravisor support"
>> +	depends on KVM_BOOK3S_HV_POSSIBLE
>> +	select HMM_MIRROR
>> +	select HMM
>> +	select ZONE_DEVICE
>> +	select MIGRATE_VMA_HELPER
>> +	select DEV_PAGEMAP_OPS
>> +	select DEVICE_PRIVATE
>> +	select MEMORY_HOTPLUG
>> +	select MEMORY_HOTREMOVE
>> +	default n
>> +	help
>> +	  This option paravirtualizes the kernel to run in POWER platforms that
>> +	  supports the Protected Execution Facility (PEF). In such platforms,
>> +	  the ultravisor firmware runs at a privilege level above the
>> +	  hypervisor.
>> +
>> +	  If unsure, say "N".
>> +
>>  config LD_HEAD_STUB_CATCH
>>  	bool "Reserve 256 bytes to cope with linker stubs in HEAD text" if EXPERT
>>  	depends on PPC64
> Maybe this patch should be the last of the series, as it may cause some
> bisect trouble to have this option enabled while missing some of the
> patches.

Thanks Leonardo. I changed that for the next version.

Claudio


